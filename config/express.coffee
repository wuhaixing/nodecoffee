express = require 'express'
path = require 'path'
mongoStore = require('connect-mongo')(express)
expressValidator = require 'express-validator'
helpers = require 'view-helpers'

module.exports = (app,config,passport) ->
    #all environments
    app.set "port", process.env.PORT or 3000

    app.set('views', "#{config.root}/app/views")
    app.set "view engine", "jade"
    app.use express.favicon()
    app.use(helpers(config.app.name))
    app.use express.logger("dev")

    app.use express.compress
        filter: (req, res) ->
          return /json|text|javascript|css/.test(res.getHeader('Content-Type'))
        level: 9


    app.use express.bodyParser(
            uploadDir:"#{config.root}/tmp"
        )

    app.use(expressValidator(
      errorFormatter: (param, msg, value)->
          namespace = param.split('.')
          root = namespace.shift()
          formParam = root

          while(namespace.length) 
            formParam += '[' + namespace.shift() + ']'
          
          param : formParam
          msg   : msg
          value : value
      ))

    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session
      secret: 'p8zztgch48rehu79jskhm6aj3'
      store: new mongoStore
        url: config.db,
        collection : 'sessions'

    app.use passport.initialize()
    app.use passport.session()

    app.use app.router

    app.use(express.static(path.join(__dirname, '../assets')))
    app.use(require('connect-assets')())

    # development only
    app.use express.errorHandler()  if "development" is app.get("env")