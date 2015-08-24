AWS = require 'aws-sdk'
fs = require 'fs'

s3Client = new (AWS.S3)(
  accessKeyId: process.env.S3_KEY
  secretAccessKey: process.env.S3_SEC)

# exports.save = (part, filename, cb) -> 
#   console.log "uploading scene image to s3, file name #{filename}, size #{part.byteCount}"
#   s3Client.putObject {
#     Bucket: 'udcb'
#     Key: filename
#     ACL: 'public-read'
#     Body: part
#     ContentLength: part.byteCount
#   }, (err, data) ->
#     cb err, data


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
