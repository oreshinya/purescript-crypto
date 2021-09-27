"use strict";

var crypto = require('crypto');

exports.createDecipherivImpl = crypto.createDecipheriv;

exports.updateImpl = function(buffer, decipher) {
  return decipher.update(buffer);
}

exports.finalImpl = function(decipher) {
  return decipher.final();
}
