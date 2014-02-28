models = require '../app/models'
User = models.User

GITHUB_CLIENT_ID = '5cebb1c539ea87b90442'
GITHUB_CLIENT_SECRET = 'fc988a1cccacc801c639be959c85491ed5de8c3f'

module.exports = (passport,config) ->

  LocalStrategy = require('passport-local').Strategy
  GoogleStrategy = require('passport-google').Strategy
  GitHubStrategy = require('passport-github').Strategy
  # Serialize sessions
  passport.serializeUser (user, done) ->
    done(null, user)
  
  passport.deserializeUser (obj, done) ->
    done(null, obj)


  # Define the local auth strategy
  passport.use new LocalStrategy 
      usernameField: 'email',passwordField: 'password'
      (email, password, done) ->
        if email? and password? and email.indexOf('@') isnt -1
          User.findByEmail email, (err, user) ->
            if err
              console.error err
              done err
              return
            if not user
              console.log "未找到#{email}相关用户信息"
              done null, false, message: '未找到相关用户信息'
              return
            if not user.active
              console.log "用户#{email}还未激活，请先登录邮箱激活该帐号"
              done null, false, message: '用户还未激活，请先登录邮箱激活该帐号'
              return
            user.comparePassword password, (err, isMatch) ->
              if err
                console.error err
                done err
                return
              if isMatch
                console.log "#{email}用户于#{new Date}登录"
                done null, user
              else
                console.log "#{email}用户登录密码输入错误"
                done null, false, message: '密码错误'
              return
        else
          done null, false, message: '无效的邮箱帐号或密码'
          

  # Define the google auth strategy        
  passport.use new GoogleStrategy
    returnURL: "http://#{config.app.host}/auth/google/return",realm: "http://#{config.app.host}/" 
    (identifier, profile, done)->
       console.log "got profile #{JSON.stringify(profile)} of #{identifier}"
       User.findByOpenId identifier, (err, contact) ->
        if contact
          done(err, contact)
        else
          contact = new Contact(profile)
          contact.contactId = identifier
          contact.provider = 'google'
          contact.save (err)->
            done(err,contact) 


  passport.use new GitHubStrategy(
    clientID: GITHUB_CLIENT_ID
    clientSecret: GITHUB_CLIENT_SECRET
    callbackURL: "http://#{config.app.host}/auth/github/callback"
    passReqToCallback: true
  , (req, token, refreshToken, profile, done) ->
    unless req.user
      app.db.models.User.findOne
        "github.id": profile.id
      , (err, user) ->
        return done(err)  if err
        unless user
          console.log "github auth: - user not found"
          gh_username = ""
          fieldsToSet = {}
          app.db.models.User.findOne
            username: profile.username
          , (err, testuser) ->
            return done(err)  if err
            unless testuser
              if /^[a-zA-Z0-9\-\_]+$/.test(profile.username)
                gh_username = profile.username
                fieldsToSet =
                  isActive: "no"
                  username: gh_username
                  email: profile.emails[0].value
                  github: profile._json

                app.db.models.User.create fieldsToSet, (err, user) ->
                  return done(err)  if err
                  done err, user
            else
              fieldsToSet =
                isActive: "no"
                username: gh_username
                email: profile.emails[0].value
                github: profile._json

              app.db.models.User.create fieldsToSet, (err, user) ->
                return done(err)  if err
                done err, user
        else
          done err, user
    else
      app.db.models.User.findOne
        _id: req.user._id
      , (err, user) ->
        return done(err)  if err
        unless user
          console.log "passport deserialize: - user not found"
          done err, req.user
        else
          user.github = profile._json
          user.save (err, user) ->
            return done(err)  if err
            done err, user

      done null, req.user
  )
