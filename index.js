// Generated by CoffeeScript 1.3.3
(function() {
  var S3sign, accessKeyId, bucket, cfg, childProcess, duration, file, http, inspect, secretAccessKey, signer, url, verb, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;

  cfg = require('nconf');

  S3sign = require('./s3sign');

  http = require('http');

  inspect = require('eyes').inspector();

  childProcess = require('child_process');

  cfg.argv().env();

  accessKeyId = (_ref = (_ref1 = cfg.get("accessKeyId")) != null ? _ref1 : cfg.get("AWS_ACCESS_KEY")) != null ? _ref : "BAD_KEY";

  secretAccessKey = (_ref2 = (_ref3 = cfg.get("secretAccessKey")) != null ? _ref3 : cfg.get("AWS_SECRET_KEY")) != null ? _ref2 : "BAD_SECRET_KEY";

  verb = (_ref4 = cfg.get("verb")) != null ? _ref4 : 'GET';

  file = (_ref5 = cfg.get("file")) != null ? _ref5 : 'file';

  bucket = (_ref6 = cfg.get("bucket")) != null ? _ref6 : 'bucket';

  duration = (_ref7 = cfg.get("duration")) != null ? _ref7 : 5;

  signer = new S3sign(accessKeyId, secretAccessKey);

  url = signer.getUrl(verb, file, bucket, 5);

  console.log("Long URL: " + url);

  http.get("http://chilp.it/api.php?url=" + escape(url), function(res) {
    return res.on('data', function(chunk) {
      return console.log('Short URL: ' + chunk);
    });
  });

  childProcess.exec("echo \"" + url + "\" | pbcopy", function(error, stdout, stderr) {
    if (error) {
      return console.log("Could not copy long URL to the clipboard");
    } else {
      return console.log("Long URL successfully copied to the clipboard");
    }
  });

}).call(this);
