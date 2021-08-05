"use strict";

var crypto = require('crypto');

// exports._createHash = (algorithm) => () => crypto.createHash(algorithm)
exports._createHash = function(algorithm) {
        return crypto.createHash(algorithm);
}

// exports._update = (hash, buffer) => () => hash.update(buffer)
exports._update = function(hash, buffer) {
        return hash.update(buffer);
}

// exports.digest = (hash) => () => hash.digest()
exports._digest = function(hash) {
        return hash.digest();
}