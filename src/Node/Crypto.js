"use strict";

var crypto = require('crypto');

exports.timingSafeEqualImpl = crypto.timingSafeEqual;

exports.randomBytesImpl = crypto.randomBytes;

exports.scryptImpl = function(password, salt, keylen) {
  return function(onError, onSuccess) {
    crypto.scrypt(password, salt, keylen, function(err, key) {
      if (err) {
        onError(err);
      } else {
        onSuccess(key);
      }
    });
    return function(cancelError, onCancelerError, onCancelerSuccess) {
      onCancelerSuccess({});
    }
  }
}

exports.scryptSyncImpl = crypto.scryptSync;
