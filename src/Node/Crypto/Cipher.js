"use strict";

var crypto = require('crypto');

// exports._createCipher = (algorithm, password) => () => crypto.createCipher(algorithm, password)
exports._createCipher = function(algorithm, password) {
    return crypto.createCipher(algorithm, password);
}

// exports._update = (cipher, buffer) => () => cipher.update(buffer)
exports._update = function(cipher, buffer) {
    return cipher.update(buffer);
}

// exports.final = (cipher) => () => cipher.final()
exports._final = function(cipher) {
    return cipher.final();
}
