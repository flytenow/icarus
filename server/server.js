var express = require('express');
var path = require('path');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var _ = require('lodash');
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

app.get('/query', function(request, response) {
  connection.query('SELECT COUNT(*) FROM events', function(err, count) {
    if (err) {
      response.status(500);
      response.send(err);
      return;
    }

    var query = 'SELECT date, fatalities, injuries FROM events ' +
      'WHERE LEFT(date, 4) >= ' + request.query.dateLow + ' AND LEFT(date,4) <= ' + request.query.dateHigh;

    connection.query(query, function(err, rows) {
      if (err) {
        response.status(500);
        response.send(err);
        return;
      }
      response.send(util.getResponse(rows, count[0]['COUNT(*)']));
    });
  });
});

var server = app.listen(3000, function() {
  console.log('Listening on port: %d', server.address().port);
});
