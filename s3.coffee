AWS = require 'aws-sdk'
fs = require 'fs'

s3Client = new (AWS.S3)(
  accessKeyId: process.env.S3_KEY
  secretAccessKey: process.env.S3_SEC)

###
@param tmp_filename : upload file is saved in ./uploads folder
@param filename : filename in s3
###
exports.save = (tmp_filename, filename, cb) -> 
  console.log "uploading scene image to s3, file name #{tmp_filename} -> #{filename}"
  fs.readFile tmp_filename, 'binary', (err, data) ->
    if err
      throw err
    base64data = new Buffer(data, 'binary')
    s3Client.putObject {
      Bucket: 'udcb'
      Key: filename
      Body: base64data
      ACL: 'public-read'
    }, (err, data) ->
      cb err, data
