module.exports = (app) ->
	home = require '../app/controllers/home'
	app.get '/', home.index
	user = require '../app/controllers/user'
	app.get '/users', user.list