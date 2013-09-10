
/**
 * Module dependencies.
 */
var express = require('express');
var http = require('http');
var path = require('path');
var fs = require('fs');
var mongoose = require('mongoose');
var passport = require('passport');
var app = express();

require('coffee-script');
require('less');
var config = require('./config/environment')[app.get('env')];

// bootstrap passport config
require('./config/passport')(passport, config);

require('./config/express')(app,config,passport);

require('./config/routes')(app);

// Bootstrap database
console.log('Connecting to database at ' + config.db);
mongoose.connect(config.db);

http.createServer(app).listen(app.get('port'), function(){
  console.log('NodeCoffee server listening on port ' + app.get('port'));
});


