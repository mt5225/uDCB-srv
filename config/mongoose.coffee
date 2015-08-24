module.exports = ->
  mongoose = require 'mongoose'
  db = mongoose.connect 'mongodb://localhost/uDCB'
  #register models
  require '../model/usm'
  return db