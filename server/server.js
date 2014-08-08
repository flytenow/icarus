var express = require('express');
var path = require('path');
var _ = require('lodash');

var app = express();

app.engine('.html', require('ejs').renderFile);
//app.set('views', path.join(__dirname, 'path/to/views'));
//app.use(express.static(path.join(__dirname, 'path/to/static')));

app.get('/', function(request, response) {
  //response.render('index.html');
  response.send('Hello, user.');
});

var server = app.listen(3000, function() {
  console.log('Listening on port: %d', server.address().port);
});
