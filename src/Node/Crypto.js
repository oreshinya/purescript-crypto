"use strict";

import crypto from "crypto";

export const timingSafeEqualImpl = crypto.timingSafeEqual;

export const randomBytesImpl = crypto.randomBytes;

export function scryptImpl(password, salt, keylen) {
  return function(onError, onSuccess) {
    crypto.scrypt(password, salt, keylen, function(err, key) {
      if (err) {
        onError(err);
      } else {
        onSuccess(key);
      }
    });
    return function(cancelError, onCancelerError, onCancelerSuccess) {
      onCancelerSuccess({});
    }
  }
}

export const scryptSyncImpl = crypto.scryptSync;
