models = require '../app/models'
User = models.User

module.exports = (passport) ->

  LocalStrategy = require('passport-local').Strategy

  # Serialize sessions
  passport.serializeUser (user, done) ->
    done(null, user)
  
  passport.deserializeUser (obj, done) ->
    done(null, obj)

  # Define the local auth strategy
  passport.use new LocalStrategy (username, password, done) ->
    User.findOne username: username, (err, user) ->
      if err
        return done err
      if !user
        return done null, false, message: '未知用户'
      
      user.comparePassword password, (err, isMatch) ->
        if err
          return done err
        if isMatch
          return done null, user
        else
          return done null, false, message: '密码错误'
      
      return
    return
  return