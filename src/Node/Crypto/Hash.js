"use strict";

var crypto = require('crypto');

exports.createHashImpl = crypto.createHash;

exports.updateImpl = function(buffer, hash) {
  return hash.update(buffer);
}

exports.digestImpl = function(hash) {
  return hash.digest();
}
