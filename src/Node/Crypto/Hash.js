"use strict";

import crypto from "crypto";

export const createHashImpl = crypto.createHash;

export function updateImpl(buffer, hash) {
  return hash.update(buffer);
}

export function digestImpl(hash) {
  return hash.digest();
}
