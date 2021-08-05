"use strict";

var crypto = require('crypto');

// exports._createDecipher = (algorithm, password) => () => crypto.createDecipher(algorithm, password)
exports._createDecipher = function(algorithm, password) {
    return crypto.createDecipher(algorithm, password);
}

// exports._update = (decipher, buffer) => () => decipher.update(buffer)
exports._update = function(decipher, buffer) {
    return decipher.update(buffer);
}

// exports.final = (decipher) => () => decipher.final()
exports._final = function(decipher) {
    return decipher.final();
}
