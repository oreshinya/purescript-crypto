"use strict";

import crypto from 'crypto';
export var createCipherivImpl = crypto.createCipheriv;

export function updateImpl(buffer, cipher) {
  return cipher.update(buffer);
}

export function finalImpl(cipher) {
  return cipher.final();
}
