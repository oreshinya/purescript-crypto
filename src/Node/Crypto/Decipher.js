"use strict";

import crypto from "crypto";

export const createDecipherivImpl = crypto.createDecipheriv;

export function updateImpl(buffer, decipher) {
  return decipher.update(buffer);
}

export function finalImpl(decipher) {
  return decipher.final();
}
