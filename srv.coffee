express = require './config/express'
mongoose = require './config/mongoose'

db = mongoose()
app = express()

#handle unity3D requests
unity3d = require './controller/unity3d_controller'
app.route('/rest/web/user/current/').get unity3d.userinfo
app.route('/rest/web/application/string/save').post unity3d.export
app.route('/rest/web/model/save/string').post unity3d.save

app.listen 8088, ->
  console.log "ready to serve at port 8088"

