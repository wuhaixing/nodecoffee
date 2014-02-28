express = require 'express'
http = require 'http'
path = require 'path'
fs = require 'fs'
mongoose = require 'mongoose'
passport = require 'passport'
app = express()

require "coffee-script"
require "less"
config = require("./config/environment")[app.get("env")]

# bootstrap passport config
require("./config/passport") passport, config
require("./config/express") app, config, passport
require("./config/routes") app, passport

# Bootstrap database
console.log "Connecting to database at " + config.db
mongoose.connect config.db
http.createServer(app).listen app.get("port"), ->
  console.log "NodeCoffee server listening on port " + app.get("port")
  return


