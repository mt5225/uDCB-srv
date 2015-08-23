AWS = require 'aws-sdk'

s3Client = new (AWS.S3)(
  accessKeyId: process.env.S3_KEY
  secretAccessKey: process.env.S3_KEY)

exports.save = (part, cb) -> 
  console.log "uploading to s3, file size #{part.byteCount}"
  s3Client.putObject {
    Bucket: 'udcb'
    Key: 'abc'
    ACL: 'public-read'
    Body: part
    ContentLength: part.byteCount
  }, (err, data) ->
    cb err, data