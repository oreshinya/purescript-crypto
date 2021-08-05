"use strict";

var crypto = require('crypto');

// exports._createDecipherIv = (algorithm, key, iv) => () => crypto.createDecipheriv(algorithm, key, iv)
exports._createDecipherIv = function(algorithm, key, iv) {
    return crypto.createDecipheriv(algorithm, key, iv);
}

// exports._update = (decipher, buffer) => () => decipher.update(buffer)
exports._update = function(decipher, buffer) {
    return decipher.update(buffer);
}

// exports._setAuthTag = (decipher, tag) => () => decipher.setAuthTag(tag)
exports._setAuthTag = function(decipher, tag) {
    return decipher.setAuthTag(tag);
}

// exports.final = (decipher) => () => decipher.final()
exports._final = function(decipher) {
    return decipher.final();
}
