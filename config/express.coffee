express = require 'express'
morgan = require 'morgan'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
cors = require 'cors'
multer = require 'multer'


module.exports = ->
  app = express()
  app.use multer(dest: './uploads/').single('file')
  app.use(morgan 'combined')
  app.use(bodyParser.urlencoded(
    extended: true
  ))
  app.use bodyParser.json({limit: '50mb'})
  app.use bodyParser.urlencoded({limit: '50mb'})
  app.use methodOverride()
  app.use cors() #enable cross-domain ajax

  app.use express.static('public')
  return app
