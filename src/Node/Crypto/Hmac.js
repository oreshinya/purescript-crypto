"use strict";

var crypto = require('crypto');

// exports._createHmac = (algorithm, secret) => () => crypto.createHmac(algorithm, secret)
exports._createHmac = function (algorithm, secret) {
    return crypto.createHmac(algorithm, secret);
}

// exports._update = (hmac, buffer) => () => hmac.update(buffer)
exports._update = function(hmac, buffer) {
    return hmac.update(buffer);
}

// exports.digest = (hmac) => () => hmac.digest()
exports._digest = function(hmac) {
    return hmac.digest();
}
