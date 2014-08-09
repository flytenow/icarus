var express = require('express');
var path = require('path');
var _ = require('lodash');
var mysql = require('mysql');
var util = require('./util');

var connection = mysql.createConnection({host: 'localhost', user: 'root', password: ''});
connection.query('USE `icarus`');

var app = express();

app.engine('.html', require('ejs').renderFile);
//app.set('views', path.join(__dirname, 'path/to/views'));
//app.use(express.static(path.join(__dirname, 'path/to/static')));

app.get('/', function(request, response) {
  //response.render('index.html');
  response.send('Hello world.')
});

app.get('/query', function(request, response) {
  connection.query('SELECT date FROM events', function(err, rows) {
    if(err) {
      response.status(500);
      response.send(err);
      return;
    }
    response.send(util.getResponse(rows));
  });
});

var server = app.listen(3000, function() {
  console.log('Listening on port: %d', server.address().port);
});
