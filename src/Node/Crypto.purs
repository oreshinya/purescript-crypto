module Node.Crypto where

import Prelude

import Effect (Effect)
import Node.Buffer (Buffer, fromString)
import Node.Crypto.Hash (Algorithm(..))
import Node.Crypto.Hmac (createHmac, digest, update)
import Node.Encoding (Encoding(..))



timingSafeEqualString :: String -> String -> Effect Boolean
timingSafeEqualString x1 x2 = do
  a1 <- fromString x1 UTF8
  a2 <- fromString x2 UTF8
  secret <- randomBytes 32
  b1 <- createHmac SHA256 secret >>= flip update a1 >>= digest
  b2 <- createHmac SHA256 secret >>= flip update a2 >>= digest
  conj (x1 == x2) <$> timingSafeEqual b1 b2



foreign import timingSafeEqual :: Buffer -> Buffer -> Effect Boolean



foreign import randomBytes :: Int -> Effect String
