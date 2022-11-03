"use strict";

import crypto from "crypto";

export const createHmacImpl = crypto.createHmac;

export function updateImpl(buffer, hmac) {
  return hmac.update(buffer);
}

export function digestImpl(hmac) {
  return hmac.digest();
}
