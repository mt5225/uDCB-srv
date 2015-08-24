USM = require('mongoose').model('USM')

#query all scene by user id
exports.get = (req, res, next) ->
  userid = req.params['userid']
  USM.find('userid': userid).exec (err, scenes) ->
    if err
      res.status(500).json {status: "error to fetch scenes for #{userid}"}
    else
      results = []
      for item in scenes
        it = {}
        it.sceneid = item.sceneid
        it.userid = item.userid
        it.name = item.name
        it.create = item.create
        it.image = item.image
        results.push it
      res.status(200).json results