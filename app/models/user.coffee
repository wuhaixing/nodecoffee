mongoose = require 'mongoose'
bcrypt = require 'bcrypt'
_ = require 'underscore'

Schema = mongoose.Schema
UserSchema = new Schema 
  
  email:
    type: String
    unique: true

  password:
    type: String

  github:{}
  google:{}
  
  url:
    type: String

  profileImage:
    type: String

  location:
    type: String

  signature:
    type: String

  profile:
    type: String

  weibo:
    type: String

  avatar:
    type: String

  score:
    type: Number
    default: 0

  topicCount:
    type: Number
    default: 0

  replyCount:
    type: Number
    default: 0

  followerCount:
    type: Number
    default: 0

  followingCount:
    type: Number
    default: 0

  collectTagCount:
    type: Number
    default: 0

  collectTopicCount:
    type: Number
    default: 0

  createdAt:
    type: Date
    default: Date.now

  updatedAt:
    type: Date
    default: Date.now

  isStar:
    type: Boolean

  level:
    type: String

  active:
    type: Boolean
    default: false

  receiveReplyMail:
    type: Boolean
    default: false

  receiveAtMail:
    type: Boolean
    default: false

  retrieveTime:
    type: Number

  retrieveKey:
    type: String

UserSchema.virtual('token').get ()->
  salt = bcrypt.genSaltSync(10)
  token = bcrypt.hashSync(@password, salt)

#
# Hash password before saving
#
UserSchema.pre 'save', (next) ->
  user = this
  SALT_WORK_FACTOR = 10

  return next() unless user.isModified 'password'

  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    if err
      console.error err
      return next err 
    bcrypt.hash user.password, salt, (err, hash) ->
      if err
        console.error err
        return next err 
      user.password = hash
      next()
      return
    return
#
# Compare password method for authentication
#
UserSchema.methods = 
  comparePassword : (candidatePassword, cb) ->
    # console.log "compare #{candidatePassword} with #{@password}"
    bcrypt.compare  candidatePassword,@password, (err, isMatch) ->
      if err
        console.error err
        return cb err
      cb(null, isMatch)

#
# Schema statics
#
UserSchema.statics =
  findByEmail: (email, cb) ->
    @findOne({ email : email })
    .select('username email password active')
    .exec(cb)
  
  findByToken: (identifier, cb) ->
    @findOne({ contactId : identifier })
    .select('contact')
    .exec(cb)

  activeByToken: (email,token,cb) ->
    @findOne({ email : email }).exec (err,user)->
      if err?
        cb err,null,0
      if user
        
        console.log "compare #{token}"
        bcrypt.compare token,user.password,(err,isMatch)->
          if err?
            console.error err
            cb err,null 
          if isMatch
            user.active = true
            user.save cb 
          else
            cb "token is not match",null,0
      else
        cb "cann't find user by email #{email}",null,0
      return 


      
User = mongoose.model 'User', UserSchema
