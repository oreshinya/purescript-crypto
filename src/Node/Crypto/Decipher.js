"use strict";

var crypto = require('crypto');

exports._createDecipher = (algorithm, password) => () => crypto.createDecipher(algorithm, password)

exports._createDecipherIv = (algorithm, password, iv) => () => crypto.createDecipheriv(algorithm, password, iv)

exports._update = (decipher, buffer) => () => decipher.update(buffer)

exports._setAuthTag = (decipher, tag) => () => decipher.setAuthTag(tag)

exports.final = (decipher) => () => decipher.final()
