mongoose = require 'mongoose'
bcrypt = require 'bcrypt'
_ = require 'underscore'
authTypes = ['github', 'weibo', 'google']

Schema = mongoose.Schema
UserSchema = new Schema 
  username:
    type: String
    index: true

  password:
    type: String

  email:
    type: String
    unique: true

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
    default: true

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

#
# Hash password before saving
#
UserSchema.pre 'save', (next) ->
  user = this
  SALT_WORK_FACTOR = 10

  if !user.isModified 'password'
    console.log 'Password not modified'
    return next()

  return next() unless user.isModified 'password'

  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    return next err if err
    bcrypt.hash user.password, salt, (err, hash) ->
      return next err if err
      user.password = hash
      next()
      return

    return

#
# Compare password method for authentication
#
UserSchema.methods = 
  comparePassword : (candidatePassword, cb) ->
    bcrypt.compare candidatePassword, this.password, (err, isMatch) ->
      if err
        return cb err
      cb(null, isMatch)
      
User = mongoose.model 'User', UserSchema
