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

var queryDatabase = function(queryString, deferred, response) {
  connection.query(queryString, function(err, result) {
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

app.get('/info', function(request, response) {
  var queryCount = function() {
    var deferred = q.defer();
    return queryDatabase('SELECT COUNT(*) FROM `events`', deferred, response);
  };

  var queryDateRange = function() {
    var deferred = q.defer();
    return queryDatabase('SELECT DISTINCT LEFT(`date`, 4) FROM `events` ORDER BY `date` DESC', deferred, response);
  };

  var queryDistinctInvestigationType = function() {
    var deferred = q.defer();
    return queryDatabase('SELECT DISTINCT `investigation-type` FROM `events`', deferred, response);
  };

  var queryDistinctFatalities = function() {
    var deferred = q.defer();
    return queryDatabase('SELECT DISTINCT `fatalities` FROM `events` ORDER BY `fatalities` DESC', deferred, response);
  };

  var queryDistinctInjuries = function() {
    var deferred = q.defer();
    return queryDatabase('SELECT DISTINCT `injuries` FROM `events` ORDER BY `injuries` DESC', deferred, response);
  };

  var queryDistinctAircraftCategories = function() {
    var deferred = q.defer();
    return queryDatabase('SELECT DISTINCT `aircraft-category` FROM `events` WHERE `aircraft-category` IS NOT NULL',
      deferred, response);
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
      return queryDistinctAircraftCategories();
    }).then(function(results) {
      info.distinct.aircraftCategory = _.pluck(results, 'aircraft-category');
      response.send(info);
    });
});

app.post('/query', function(request, response) {
  var query = "SELECT `date`, `fatalities`, `injuries` FROM `events` " +
    "WHERE LEFT(`date`, 4) >= " + request.body.date.low + " AND LEFT(`date`, 4) <= " + request.body.date.high +
    " AND `fatalities` >= " + request.body.fatalities.low + " AND `fatalities` <= " + request.body.fatalities.high +
    " AND `injuries` >= " + request.body.injuries.low + " AND `injuries` <= " + request.body.injuries.high;

  var utilizationQuery = "SELECT COUNT(*) FROM `events` WHERE `date` IS NOT NULL AND `fatalities` IS NOT NULL AND" +
    " `injuries` IS NOT NULL";

  if (request.body.source && request.body.source !== "") {
    query += " AND (`source` = '" + request.body.source + "' OR `source` = 'BOTH')";
    utilizationQuery += " AND `source` IS NOT NULL";
  }

  if (request.body.investigationType && request.body.investigationType !== '') {
    query += " AND `investigation-type` = '" + request.body.investigationType + "'";
    utilizationQuery += " AND `investigation-type` IS NOT NULL";
  }

  if (request.body.aircraftCategory && request.body.aircraftCategory !== '') {
    query += " AND `aircraft-category` = '" + request.body.aircraftCategory + "'";
    utilizationQuery += " AND `aircraft-category` IS NOT NULL";
  }

  console.log(query);
  console.log(utilizationQuery);

  var queryRows = function() {
    var deferred = q.defer();
    return queryDatabase(query, deferred, response);
  };

  var queryUtilization = function() {
    var deferred = q.defer();
    return queryDatabase(utilizationQuery, deferred, response);
  };

  var data = {};
  queryRows().then(function(results) {
    data.rows = results;
    return queryUtilization();
  })
    .then(function(results) {
      data.utilization = results[0]['COUNT(*)'];
      response.send(util.getResponse(data.rows, data.utilization));
    });
});

var server = app.listen(3000, function() {
  console.log('Listening on port: %d', server.address().port);
});
