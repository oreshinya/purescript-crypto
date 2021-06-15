"use strict";

var crypto = require('crypto');

exports._createHash = (algorithm) => () => crypto.createHash(algorithm)

exports._update = (hash, buffer) => () => hash.update(buffer)

exports.digest = (hash) => () => hash.digest()
