"use strict";

var crypto = require('crypto');

exports._createHmac = (algorithm, secret) => () => crypto.createHmac(algorithm, secret)

exports._update = (hmac, buffer) => () => hmac.update(buffer)

exports.digest = (hmac) => () => hmac.digest()
