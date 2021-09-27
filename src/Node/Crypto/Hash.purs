module Node.Crypto.Hash
  ( Hash
  , createHash
  , update
  , digest
  ) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer)

-- | [https://nodejs.org/api/crypto.html#crypto_class_hash](https://nodejs.org/api/crypto.html#crypto_class_hash)
-- |
-- | Usage:
-- |
-- | ```
-- | buf <- Buffer.fromString "dummy" UTF8
-- | Hash.createHash "sha512" >>= Hash.update buf >>= Hash.digest >>= Buffer.toString Hex
-- | ```
foreign import data Hash :: Type

createHash :: String -> Effect Hash
createHash alg = runEffectFn1 createHashImpl alg

update :: Buffer -> Hash -> Effect Hash
update buf hash = runEffectFn2 updateImpl buf hash

digest :: Hash -> Effect Buffer
digest hash = runEffectFn1 digestImpl hash

foreign import createHashImpl :: EffectFn1 String Hash
foreign import updateImpl :: EffectFn2 Buffer Hash Hash
foreign import digestImpl :: EffectFn1 Hash Buffer
