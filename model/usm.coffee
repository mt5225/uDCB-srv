mongoose = require 'mongoose'

#register for data model
Schema = mongoose.Schema

USMSchema = new Schema (
  sceneid: String #unique id : name_userid
  userid: String #userid
  name: String
  image: String #image url
  public: String  # public
  create: String
  uuid: String
  resource: String
  )
mongoose.model 'USM', USMSchema