"use strict";

var crypto = require('crypto');

exports.createHmacImpl = crypto.createHmac;

exports.updateImpl = function(buffer, hmac) {
  return hmac.update(buffer);
}

exports.digestImpl = function(hmac) {
  return hmac.digest();
}
