"use strict";

var crypto = require('crypto');

exports._timingSafeEqual = function(b1, b2) {
      return crypto.timingSafeEqual(b1, b2);
}

exports._randomBytes = function(size) {
    return crypto.randomBytes(size);
}
