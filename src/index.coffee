#! /usr/local/bin/node
cfg = require 'nconf'
S3sign = require './s3sign'
http = require 'http'
inspect = require('eyes').inspector()
childProcess = require 'child_process'

cfg.argv().env()

if cfg.get("help")
	console.log ""
	console.log "usage: s3sign --bucket BUCKET_NAME        : the name of your bucket"
	console.log "              --file FILE_NAME            : full pathname of your file"
	console.log "             [--duration TIME_IN_MINUTES] : expiration in minutes (defaults to 5)"
	console.log "             [--accessKeyId <ACCESS_KEY>] : your access key (defaults to AWS_ACCESS_KEY env. var."
	console.log "             [--secretAccessKey <SECRET>] : your secret key (defaults to AWS_SECRET_KEY env. var."
	console.log "             [--verb GET|POST]            : HTTP verb (defaults to GET"
	console.log ""
	process.exit(0)

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
