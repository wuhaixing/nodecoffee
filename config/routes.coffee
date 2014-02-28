module.exports = (app,passport) ->
    home = require '../app/controllers/home'
    user = require '../app/controllers/user'

    app.get '/', home.index
    
    app.get '/signup', user.signupView
    app.get '/validate/signup/email',user.signupValidateEmail
    app.post '/signup', user.signup
    app.get '/account/active', user.active

    app.get '/login',user.loginView
    app.post '/login', passport.authenticate('local',
        failureRedirect: '/login'
        failureFlash: true),
        (req, res) ->
          res.redirect '/'
          return
    app.get '/auth/google', passport.authenticate('google')
    app.get '/auth/google/return', passport.authenticate('google', 
        successRedirect: '/'
        failureRedirect: '/login' 
        stateless: true
        failureFlash: true)

    app.get '/auth/github',passport.authenticate('github')
    app.get '/auth/github/callback', 
      passport.authenticate('github', { failureRedirect: '/login' }),
      (req, res)->
        res.redirect('/')

    app.get '/logout', user.logout   
       
    app.get '/users', user.list