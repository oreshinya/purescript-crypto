"use strict";

import crypto from "crypto";

export const createCipherivImpl = crypto.createCipheriv;

export function updateImpl(buffer, cipher) {
  return cipher.update(buffer);
}

export function finalImpl(cipher) {
  return cipher.final();
}
