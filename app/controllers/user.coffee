models = require '../models'
User = models.User
###
#
# GET user signup view
###

exports.signup = (req, res) ->
  res.render 'users/signup',
    user : new User()

exports.signupValidateEmail = (req, res) ->
  console.log("check email:#{req.query.email} for signup")
  req.assert('email', '请提供有效的邮箱地址').isEmail()
  req.sanitize('email')

  errors = req.validationErrors()
  if errors?
    res.send
        valid:false
        errors:errors[0].msg

  email = req.query.email

  User.findOne({email:email}).exec (err,user)->
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

exports.register = (req,res)->
  console.log("save user:#{req.body.email} from signup")
  req.checkBody('username', '用户名的长度应该在2到12个字符之间').len(2,12)
  req.sanitize('username').xss()
  req.checkBody('email', '请提供有效的邮箱地址').isEmail()
  req.sanitize('email').xss()
  req.checkBody('password', '密码不能少于7个字符').len(7,64)
  req.sanitize('password').xss()

  err = req.validationErrors()
  user = new User req.body
  if err?
    res.render 'users/signup',
        errors:err
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

        res.redirect '/'
    return
###
#
# GET users listing.
###

exports.list = (req, res) ->
  res.send 'respond with a resource'
