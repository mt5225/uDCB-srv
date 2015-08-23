###
uDCB message dump
###

http = require 'http'
url = require 'url'
fs = require "fs"
qs = require "querystring"
nodeutil = require 'util'
multiparty = require 'multiparty'
s3 = require './s3'
util = require "./util"

server = http.createServer (req, res) ->
  pathname  = url.parse(req.url).pathname
  console.log "request from unity #{pathname}"
  switch req.method    
    when "GET"    
      switch pathname
        when '/rest/web/user/current/'
          console.log "/rest/web/user/current/ request for current user"
          if util.parseCookies(req).userid?
            userid = util.parseCookies(req).userid
            console.log "userid = #{userid}"
            res.writeHead 200
            res.write """
            {"state":true,"content":{"qrsharecount":0,"idolcount":0,"username":"mt52252","joindate":"Aug 14, 2015 9:28:30 PM","source":"momoda","fanscount":0,"status":1,"email":"mt5225@outlook.com","userid":#{userid},"zuopincount":0,"companyscale":0,"usertype":"免费版","shoucangcount":0,"privatecount":0,"screencount":0},"time":"2015-08-23 12:05:55"}
            """
            res.end()
        else
          console.log "default: request for crossdomain.xml"
          fs.readFile "crossdomain.xml", "binary", (err,file) ->
            if err
                res.writeHead 500, 'Content-Type': 'text/plain'
                res.end "Error #{uri}: #{err} \n"
                return
            res.writeHead 200
            res.write file, "binary"
            res.end()
      return
    when "POST"
      #get post body
      switch pathname
        when "/rest/web/application/string/save" #export json
          console.log "/rest/web/application/string/save : export scene file"    
          body = ''
          req.on 'data', (data) ->
            body += data
            # 1e6 === 1 * Math.pow(10, 6) === 1 * 1000000 ~~~ 1MB
            if body.length > 1e6
              # FLOOD ATTACK OR FAULTY CLIENT, NUKE REQUEST
              req.connection.destroy()
            return
          req.on 'end', ->              
            POST = qs.parse(body)
            msgBody = JSON.parse(POST['param'])
            timeStr = util.getDateTime()
            exportFile = "/Users/mt5225/Projects/corpwebsite/dcv_en_web/exported/udbcexport_#{timeStr}.json"
            #exportFile = "/usr/share/nginx/mbts_24_Cubic/exported/udbcexport_#{timeStr}.json"
            console.log "export scene file to #{exportFile}"
            fs.writeFile exportFile, msgBody.content, (err) ->
              if err
                return console.log(err)
              msg = {}
              msg.state = true
              msg.content = "exported/udbcexport_#{timeStr}.json"
              res.writeHead 200, 'Content-Type': 'application/json'
              res.write JSON.stringify(msg)
              res.end()
              return
        when "/rest/web/model/save/string" #save scene
          console.log "/rest/web/application/string/save : save scene"
          form = new multiparty.Form()
          form.on 'field', (name, value) ->
            console.log "#{name} : #{value}"
            return
          form.on 'part', (part) ->
            # You *must* act on the part by reading it
            if part.filename
              console.log "save sceen capture image to s3"
              # s3.save part, (err, data) ->
              #   if err
              #     console.log err
              #     res.writeHead 500
              #     res.end()
              #     return                 
              #   console.log("done", data)
              #   res.writeHead 200, 'Content-Type': 'application/json'
              #   msg = {}
              #   res.write JSON.stringify(msg)
              #   res.end()
          form.parse req

        else #else return {}
          res.writeHead 200, 'Content-Type': 'application/json'
          msg = {}
          res.write JSON.stringify(msg)
          res.end()
          return
  
server.listen 8088
