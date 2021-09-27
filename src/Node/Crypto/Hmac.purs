module Node.Crypto.Hmac
  ( Hmac
  , createHmac
  , update
  , digest
  ) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer)

-- | [https://nodejs.org/api/crypto.html#crypto_class_hmac](https://nodejs.org/api/crypto.html#crypto_class_hmac)
-- |
-- | Usage:
-- |
-- | ```
-- | buf <- Buffer.fromString "dummy" UTF8
-- | key <- Buffer.fromString "key" UTF8
-- | Hmac.createHmac "sha512" key >>= Hmac.update buf >>= Hmac.digest >>= Buffer.toString Hex
-- | ```
foreign import data Hmac :: Type

createHmac :: String -> Buffer -> Effect Hmac
createHmac alg key =
  runEffectFn2 createHmacImpl alg key

update :: Buffer -> Hmac -> Effect Hmac
update buf hmac = runEffectFn2 updateImpl buf hmac

digest :: Hmac -> Effect Buffer
digest hmac = runEffectFn1 digestImpl hmac

foreign import createHmacImpl :: EffectFn2 String Buffer Hmac
foreign import updateImpl :: EffectFn2 Buffer Hmac Hmac
foreign import digestImpl :: EffectFn1 Hmac Buffer
