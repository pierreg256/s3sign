#! /usr/local/bin/node
cfg = require 'nconf'
S3sign = require './s3sign'
http = require 'http'
inspect = require('eyes').inspector()
childProcess = require 'child_process'

cfg.argv().env()
accessKeyId = cfg.get("accessKeyId") ? cfg.get("AWS_ACCESS_KEY") ? "BAD_KEY"
secretAccessKey = cfg.get("secretAccessKey") ? cfg.get("AWS_SECRET_KEY") ? "BAD_SECRET_KEY"
verb = cfg.get("verb") ? 'GET'
file = cfg.get("file") ? 'file'
bucket = cfg.get("bucket") ? 'bucket'
duration = cfg.get("duration") ? 5

signer = new S3sign(accessKeyId, secretAccessKey)

url = signer.getUrl(verb, file, bucket, 5)

console.log("Long URL: " + url)

http.get "http://chilp.it/api.php?url="+escape(url), (res)-> 
	res.on 'data', (chunk) ->
    	console.log('Short URL: ' + chunk);
 
childProcess.exec ("echo \"" + url + "\" | pbcopy"), ( error, stdout, stderr ) ->
	if error
		console.log "Could not copy long URL to the clipboard" 
	else
		console.log "Long URL successfully copied to the clipboard"
