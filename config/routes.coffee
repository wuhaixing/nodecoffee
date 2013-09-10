module.exports = (app) ->
    home = require '../app/controllers/home'
    app.get '/', home.index
    user = require '../app/controllers/user'
    app.get '/signup', user.signup
    app.get '/validate/signup/email',user.signupValidateEmail
    app.post '/signup', user.register
    app.get '/users', user.list