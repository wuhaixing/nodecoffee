models = require '../models'
User = models.User

mail = require '../services/mail'
###
#
# GET user signup view
###

exports.signupView = (req, res) ->
  res.render 'users/signup',
    user : new User()

exports.signupValidateEmail = (req, res) ->
  console.log("check email:#{req.query.email} for signup")
  req.assert('email', '请提供有效的邮箱地址').isEmail()
  req.sanitize('email').xss()

  errors = req.validationErrors()
  if errors?
    res.send
        valid:false
        errors:errors[0].msg

  email = req.query.email

  User.findByEmail email,(err,user)->
    if err?
        console.error(err)
        res.send
            valid:false
            errors:err
    if user?
        res.send
            valid:false
            errors:'该邮箱已注册，请检查你的地址'
    else
        res.send
            valid:true
###
# save signup user
###
exports.signup = (req,res)->
  console.log("save user:#{req.body.email} from signup")
  req.checkBody('displayName', '用户名的长度应该在2到12个字符之间').len(2,12)
  req.sanitize('displayName').xss()
  req.checkBody('email', '请提供有效的邮箱地址').isEmail()
  req.sanitize('email').xss()
  req.checkBody('password', '密码不能少于7个字符').len(7,64)
  req.sanitize('password').xss()

  err = req.validationErrors()
  user = new User req.body
  user.provier = 'local'
  if err?
    res.render 'users/signup',
        errors:err
        user: user
  else
    User.findByEmail user.email,(err,existedUser)->
    if err?
        console.error(err)
        res.render 'users/signup',
            errors:[
                    msg:"系统错误:#{err.errors}"
                ] 
            user: user
    if existedUser?
        res.render 'users/signup',
                errors:[
                    msg:"邮件地址#{email}已注册"
                ] 
                user: user
    else    
        user.save (err) ->
            if err?
              console.error(err.errors)
              res.render 'users/signup',
                errors:[
                    msg:"系统错误:#{err.errors}"
                ] 
                user: user
            console.log "user #{user.email} is saved ,send email"
            mail.sendActiveMail user.email,user.displayName,user.token
            res.render 'notify',
                msg: "欢迎加入！我们已给你的注册邮箱发送了一封邮件，请点击里面的链接来激活您的帐号。"
        return

exports.active = (req,res)->
  req.assert('email', '邮箱地址无效，请检查你的链接').notEmpty().isEmail()
  req.assert('token', '未发现激活码，请检查你的链接').notEmpty()
  token = req.query.token
  email = req.query.email
  console.log "active user of #{email} by #{token}"
  err = req.validationErrors()  
  if err?
    user = new User({email:email}) 
    res.render 'users/signup',
        errors:err
        user: user

  User.activeByToken email,token,(err,user,affected)->
    if err?
      console.error err
      res.render 'notify',
        msg: err
    req.user = user
    res.redirect '/'

exports.loginView = (req, res) ->
  res.render 'users/login'

#
# Logout
#
exports.logout = (req, res) ->
  req.logout()
  res.redirect '/'
  return
###
#
# GET users listing.
###

exports.list = (req, res) ->
  res.send 'respond with a resource'
