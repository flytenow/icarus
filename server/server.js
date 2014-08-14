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

  var queryDistinctFatalities = function() {
    var deferred = q.defer();
    return doQuery('SELECT DISTINCT `fatalities` FROM `events` ORDER BY `fatalities` DESC', deferred);
  };

  var queryDistinctInjuries = function() {
    var deferred = q.defer();
    return doQuery('SELECT DISTINCT `injuries` FROM `events` ORDER BY `injuries` DESC', deferred);
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
      return queryDistinctFatalities();
    }).then(function(results) {
      info.range.fatalities = {ceil: results[0].fatalities, floor: results[results.length - 2].fatalities};
      return queryDistinctInjuries();
    }).then(function(results) {
      info.range.injuries = {ceil: results[0].injuries, floor: results[results.length - 2].injuries};
      response.send(info);
    });
});

app.post('/query', function(request, response) {
  connection.query('SELECT COUNT(*) FROM events', function(err, count) {
    if (err) {
      response.status(500);
      response.send(err);
      return;
    }

    var query = "SELECT `date`, `fatalities`, `injuries` FROM `events` " +
      "WHERE LEFT(`date`, 4) >= " + request.body.date.low + " AND LEFT(`date`, 4) <= " + request.body.date.high +
      " AND `fatalities` >= " + request.body.fatalities.low + " AND `fatalities` <= " + request.body.fatalities.high +
      " AND `injuries` >= " + request.body.injuries.low + " AND `injuries` <= " + request.body.injuries.high;

    if (request.body.source && request.body.source !== "") {
      query += " AND (`source` = '" + request.body.source + "' OR `source` = 'BOTH')";
    }

    if (request.body.investigationType && request.body.investigationType !== "") {
      query += " AND `investigation-type` = '" + request.body.investigationType + "'";
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
