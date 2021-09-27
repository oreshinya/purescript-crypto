"use strict";

var crypto = require('crypto');

exports.createCipherivImpl = crypto.createCipheriv;

exports.updateImpl = function(buffer, cipher) {
  return cipher.update(buffer);
}

exports.finalImpl = function(cipher) {
  return cipher.final();
}
