"use strict";

var crypto = require('crypto');

exports._createCipher = (algorithm, password) => () => crypto.createCipher(algorithm, password)

exports._createCipherIv = (algorithm, password, iv) => () => crypto.createCipheriv(algorithm, password, iv)

exports.getAuthTag = (cipher) => () => cipher.getAuthTag()

exports._update = (cipher,buffer) => () => cipher.update(buffer)

exports.final = (cipher) => () => cipher.final()
