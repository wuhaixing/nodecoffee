express = require 'express'
path = require 'path'

module.exports = (app) ->
	#all environments
	app.set "port", process.env.PORT or 3000
	app.set "views", __dirname + "/../app/views"
	app.set "view engine", "jade"
	app.use express.favicon()
	app.use express.logger("dev")
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser("p8zztgch48rehu79jskhm6aj3")
	app.use express.session()
	app.use app.router
	app.use require("less-middleware")(src: __dirname + "/public")
	app.use express.static(path.join(__dirname, "public"))
	# development only
	app.use express.errorHandler()  if "development" is app.get("env")