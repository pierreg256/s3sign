// Generated by CoffeeScript 1.3.3
(function() {
  var S3sign, crypto, join;

  join = require('path').join;

  crypto = require('crypto');

  S3sign = (function() {

    function S3sign(key, secret, options) {
      var _ref, _ref1, _ref2;
      this.key = key;
      this.secret = secret;
      if (options == null) {
        options = {};
      }
      this.endpoint = (_ref = options.host) != null ? _ref : 's3.amazonaws.com';
      this.port = (_ref1 = options.port) != null ? _ref1 : 80;
      this.protocol = (_ref2 = options.protocol) != null ? _ref2 : 'http';
    }

    S3sign.prototype.getUrl = function(verb, fname, bucket, expiresInMinutes) {
      var epo, expires, hashed, str, trailingSlash, urlRet;
      expires = new Date();
      expires.setMinutes(expires.getMinutes() + expiresInMinutes);
      epo = Math.floor(expires.getTime() / 1000);
      trailingSlash = fname[0] !== '/' ? '/' : '';
      str = verb + '\n\n\n' + epo + '\n' + '/' + bucket + trailingSlash + fname;
      hashed = this._hmacSha1(str);
      urlRet = this._url(fname, bucket) + '?Expires=' + epo + '&AWSAccessKeyId=' + this.key + '&Signature=' + encodeURIComponent(hashed);
      return urlRet;
    };

    S3sign.prototype._hmacSha1 = function(message) {
      return crypto.createHmac('sha1', this.secret).update(message).digest('base64');
    };

    S3sign.prototype._url = function(fname, bucket) {
      var strPort, trailingSlash;
      if (this.port !== 80) {
        strPort = ':' + this.port;
      } else {
        strPort = '';
      }
      trailingSlash = fname[0] !== '/' ? '/' : '';
      return this.protocol + '://' + bucket + '.' + this.endpoint + strPort + trailingSlash + fname;
    };

    return S3sign;

  })();

  module.exports = S3sign;

}).call(this);
