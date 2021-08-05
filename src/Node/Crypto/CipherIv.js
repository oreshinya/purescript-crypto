"use strict";

var crypto = require('crypto');

// exports._createCipherIv = (algorithm, key, iv) => () => crypto.createCipheriv(algorithm, key, iv)
exports._createCipherIv = function(algorithm, key, iv) {
    return crypto.createCipheriv(algorithm, key, iv);
}

// exports._getAuthTag = (cipher) => () => cipher.getAuthTag()
exports._getAuthTag = function(cipher) {
    return cipher.getAuthTag();
}

// exports._update = (cipher, buffer) => () => cipher.update(buffer)
exports._update = function(cipher, buffer) {
    return cipher.update(buffer);
}

// exports.final = (cipher) => () => cipher.final()
exports._final = function(cipher) {
    return cipher.final();
}
