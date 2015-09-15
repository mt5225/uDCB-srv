fs = require 'fs'
USM = require('mongoose').model('USM')
util = require '../util'
s3 = require '../s3'

#return userinfo
exports.userinfo = (req, res, next) ->
  if util.parseCookies(req).userid?
    userid = util.parseCookies(req).userid
    console.log "userid = #{userid}"
    if userid is "anonymous"
      userid = 9999
    userinfoStr = 
    """
    {"state":true,"content":{"qrsharecount":0,"idolcount":0,"username":"uDCB","joindate":"Aug 14, 2015 9:28:30 PM","source":"momoda","fanscount":0,"status":1,"email":"mt5225@outlook.com","userid":#{userid},"zuopincount":0,"companyscale":0,"usertype":"免费版","shoucangcount":0,"privatecount":0,"screencount":0},"time":"2015-08-23 12:05:55"}
    """
    res.status(200).json JSON.parse(userinfoStr)
  else
    console.log "could get userid"
    res.status(500).json {state: false}

#export scene to local json file
exports.export = (req, res, next) ->
  console.log "/rest/web/application/string/save : export scene file"
  msgBody = JSON.parse req.param('param')
  #console.log msgBody
  timeStr = util.getDateTime()
  #exportFile = "/Users/mt5225/Projects/corpwebsite/dcv_en_web/exported/udbcexport_#{timeStr}.json"
  exportFile = "/usr/share/nginx/mbts_24_Cubic/exported/udbcexport_#{timeStr}.json"
  console.log "export scene file to #{exportFile}"
  fs.writeFile exportFile, msgBody.content, (err) ->
    if err
      res.status(500).json {state: false}
    else
      res.status(200).json {state: true, content: "exported/udbcexport_#{timeStr}.json"}

#save scene
exports.save = (req, res, next) ->
  userid = util.parseCookies(req).userid
  if userid is 'anonymous'
    console.log "anonymous user, donot save"
    res.status(200).json {state: true}
    return
  uuid = util.uuid()
  filename = "#{uuid}.jpg"
  #upload screen capture to aws s3
  s3.save req.file['path'], filename, (err, data) ->
    if err
      console.log err
      res.status(500).json {state: false}
    else
      console.log "Successfully upload #{req.file['path']} image to aws s3."
      ##update or create usm
      msgBody = JSON.parse req.param('param')
      #console.log msgBody
      userid = util.parseCookies(req).userid
      usm = new USM()
      usm.userid = userid
      usm.name = msgBody.name
      usm.sceneid = "#{usm.name}_#{usm.userid}"
      usm.resource = msgBody.resource
      usm.image = "https://s3-us-west-1.amazonaws.com/udcb/#{filename}"
      usm.create = util.getDateTime()
      usm.uuid = uuid
      usm.public = true
      upsertData = usm.toObject();
      delete upsertData._id
      USM.update({sceneid: usm.sceneid}, upsertData, {upsert: true}, (err) ->
        if err
          console.log err
          res.status(500).json {state: false}
        else
          res.status(200).json {state: true}
      )


