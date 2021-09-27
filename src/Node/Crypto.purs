module Node.Crypto
  ( timingSafeEqual
  , randomBytes
  , scrypt
  , scryptSync
  ) where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Node.Buffer (Buffer)

-- | [https://nodejs.org/api/crypto.html#crypto_crypto_timingsafeequal_a_b](https://nodejs.org/api/crypto.html#crypto_crypto_timingsafeequal_a_b)
timingSafeEqual :: Buffer -> Buffer -> Effect Boolean
timingSafeEqual a b = runEffectFn2 timingSafeEqualImpl a b

-- | [https://nodejs.org/api/crypto.html#crypto_crypto_randombytes_size_callback](https://nodejs.org/api/crypto.html#crypto_crypto_randombytes_size_callback)
randomBytes :: Int -> Effect Buffer
randomBytes size = runEffectFn1 randomBytesImpl size

-- | [https://nodejs.org/api/crypto.html#crypto_crypto_scrypt_password_salt_keylen_options_callback](https://nodejs.org/api/crypto.html#crypto_crypto_scrypt_password_salt_keylen_options_callback)
scrypt :: Buffer -> Buffer -> Int -> Aff Buffer
scrypt password salt keylen =
  fromEffectFnAff $ runFn3 scryptImpl password salt keylen

-- | [https://nodejs.org/api/crypto.html#crypto_crypto_scryptsync_password_salt_keylen_options](https://nodejs.org/api/crypto.html#crypto_crypto_scryptsync_password_salt_keylen_options)
scryptSync :: Buffer -> Buffer -> Int -> Effect Buffer
scryptSync password salt keylen =
  runEffectFn3 scryptSyncImpl password salt keylen

foreign import timingSafeEqualImpl :: EffectFn2 Buffer Buffer Boolean
foreign import randomBytesImpl :: EffectFn1 Int Buffer
foreign import scryptImpl :: Fn3 Buffer Buffer Int (EffectFnAff Buffer)
foreign import scryptSyncImpl :: EffectFn3 Buffer Buffer Int Buffer
