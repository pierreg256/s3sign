join = require('path').join
crypto = require('crypto')

class S3sign
	constructor: (@key, @secret, options)->
		options ?= {}
		@endpoint = options.host ? 's3.amazonaws.com'
		@port = options.port ? 80
		@protocol = options.protocol ? 'http'

	getUrl: (verb, fname, bucket, expiresInMinutes) ->
		expires = new Date()
		expires.setMinutes(expires.getMinutes() + expiresInMinutes)
		epo = Math.floor(expires.getTime()/1000)
		trailingSlash = if fname[0] isnt '/' then '/' else ''
		str = verb + '\n\n\n' + epo + '\n' + '/' + bucket + trailingSlash + fname
		hashed = @_hmacSha1(str)

		urlRet = @_url(fname, bucket) +
		'?Expires=' + epo +
		'&AWSAccessKeyId=' + @key +
		'&Signature=' + encodeURIComponent(hashed)

		return urlRet


	_hmacSha1: (message) ->
		crypto.createHmac('sha1', @secret).update(message).digest('base64')


	_url: (fname, bucket) ->
		if @port isnt 80
			strPort = ':'+@port
		else
			strPort = ''

		trailingSlash = if fname[0] isnt '/' then '/' else ''

		@protocol + '://' + bucket + '.' + @endpoint + strPort + trailingSlash + fname


module.exports = S3sign
