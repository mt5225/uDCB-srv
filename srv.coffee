###
uDCB message dump
###

http = require 'http'
url = require 'url'
fs = require "fs"
qs = require "querystring"

server = http.createServer (req, res) ->
  pathname  = url.parse(req.url).pathname
  console.log pathname
  switch req.method    
    when "GET"    
      console.log "return crossdomain.xml #{pathname}"
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
      if pathname is "/rest/web/application/string/save" #export json
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
          # use POST
          #console.log JSON.parse(POST['param'])
          msgBody = JSON.parse(POST['param'])
          fs.writeFile '/Users/mt5225/Projects/corpwebsite/dcv_en_web/exported/udbcexport.json', msgBody.content, (err) ->
          #fs.writeFile '/usr/share/nginx/mbts_24_Cubic/exported/udbcexport.json', msgBody.content, (err) ->
            if err
              return console.log(err)
            console.log 'The file was saved to udbcexport.json'
            msg = {}
            msg.state = true
            msg.content = "exported/udbcexport.json"
            res.writeHead 200, 'Content-Type': 'application/json'
            res.write JSON.stringify(msg)
            res.end()
            return
      else #else return {}
        res.writeHead 200, 'Content-Type': 'application/json'
        msg = {}
        res.write JSON.stringify(msg)
        res.end()      
  

server.listen 8088
