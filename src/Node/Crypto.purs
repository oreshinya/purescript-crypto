module Node.Crypto where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer, fromString, toString)
import Node.Crypto.Hash (Algorithm(..))
import Node.Crypto.Hmac (createHmac, digest, update)
import Node.Encoding (Encoding(..))


timingSafeEqualString :: String -> String -> Effect Boolean
timingSafeEqualString x1 x2 = do
  a1 <- fromString x1 UTF8
  a2 <- fromString x2 UTF8
  key <- randomBytes 32 >>= toString UTF8
  b1 <- createHmac SHA256 key >>= flip update a1 >>= digest
  b2 <- createHmac SHA256 key >>= flip update a2 >>= digest
  conj (x1 == x2) <$> timingSafeEqual b1 b2

timingSafeEqual :: Buffer -> Buffer -> Effect Boolean
timingSafeEqual = runEffectFn2 _timingSafeEqual

foreign import _timingSafeEqual :: EffectFn2 Buffer Buffer Boolean


randomBytes :: Int -> Effect Buffer
randomBytes = runEffectFn1 _randomBytes

foreign import _randomBytes :: EffectFn1 Int Buffer
