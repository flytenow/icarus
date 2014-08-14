var express = require('express');
var path = require('path');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var _ = require('lodash');
var q = require('q');
var util = require('./util');

var connection = mysql.createConnection({host: 'localhost', user: 'root', password: ''});
connection.query('USE `icarus`');

var app = express();

app.engine('.html', require('ejs').renderFile);
app.set('views', path.join(__dirname, '../client/views'));
app.use(express.static(path.join(__dirname, '../client/static')));
app.use('/vendor', express.static(path.join(__dirname, '../client/bower_components')));
app.use(bodyParser.json());

app.get('/', function(request, response) {
  response.render('index.html');
});

app.get('/info', function(request, response) {
  var doQuery = function(query, deferred) {
    connection.query(query, function(err, result) {
      if (err) {
        response.status(500);
        response.send(err);
        deferred.reject();
        return;
      }
      deferred.resolve(result);
    });
    return deferred.promise;
  };

  var queryCount = function() {
    var deferred = q.defer();
    return doQuery('SELECT COUNT(*) FROM `events`', deferred);
  };

  var queryDateRange = function() {
    var deferred = q.defer();
    return doQuery('SELECT DISTINCT LEFT(`date`, 4) FROM `events` ORDER BY `date` DESC', deferred);
  };

  var queryDistinctInvestigationType = function() {
    var deferred = q.defer();
    return doQuery('SELECT DISTINCT `investigation-type` FROM `events`', deferred);
  };

  var info = {distinct: {}, range: {}};

  queryCount().then(function(results) {
    info.maxRows = results[0]['COUNT(*)'];
    return queryDateRange();
  })
    .then(function(results) {
      info.range.date = {ceil: +results[0]['LEFT(`date`, 4)'], floor: +results[results.length - 1]['LEFT(`date`, 4)']};
      return queryDistinctInvestigationType();
    })
    .then(function(results) {
      info.distinct.investigationType = _.pluck(results, 'investigation-type');
      response.send(info);
    })
});

app.get('/query', function(request, response) {
  connection.query('SELECT COUNT(*) FROM events', function(err, count) {
    if (err) {
      response.status(500);
      response.send(err);
      return;
    }

    var query = "SELECT `date`, `fatalities`, `injuries` FROM `events` " +
      "WHERE LEFT(`date`, 4) >= " + request.query.dateLow + " AND LEFT(`date`, 4) <= " + request.query.dateHigh;

    if (request.query.source && request.query.source !== "") {
      query += " AND (`source` = '" + request.query.source + "' OR `source` = 'BOTH')";
    }

    if (request.query.investigationType && request.query.investigationType !== "") {
      query += " AND `investigation-type` = '" + request.query.investigationType + "'";
    }

    connection.query(query, function(err, rows) {
      if (err) {
        response.status(500);
        response.send(err);
        return;
      }
      response.send(util.getResponse(rows));
    });
  });
});

var server = app.listen(3000, function() {
  console.log('Listening on port: %d', server.address().port);
});
