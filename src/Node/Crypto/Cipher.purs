module Node.Crypto.Cipher
  ( Cipher
  , createCipheriv
  , update
  , final
  ) where

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Node.Buffer (Buffer)

-- | [https://nodejs.org/api/crypto.html#crypto_class_cipher](https://nodejs.org/api/crypto.html#crypto_class_cipher)
-- |
-- | Usage:
-- |
-- | ```
-- | buf <- Buffer.fromString "dummy" UTF8
-- | pbuf <- Buffer.fromString "password" UTF8
-- | sbuf <- Buffer.fromString "salt" UTF8
-- | key <- Crypto.scryptSync pbuf sbuf 32
-- | iv <- Buffer.fromString "iviviviviviviviv" UTF8
-- | cip <- Cipher.createCipheriv "aes256" key (Just iv)
-- | rbuf1 <- Cipher.update buf cip
-- | rbuf2 <- Cipher.final cip
-- | Buffer.concat [ rbuf1, rbuf2 ] >>= Buffer.toString Hex
-- | ```
foreign import data Cipher :: Type

createCipheriv :: String -> Buffer -> Maybe Buffer -> Effect Cipher
createCipheriv alg key iv =
  runEffectFn3 createCipherivImpl alg key (toNullable iv)

update :: Buffer -> Cipher -> Effect Buffer
update buf cipher = runEffectFn2 updateImpl buf cipher

final :: Cipher -> Effect Buffer
final cipher = runEffectFn1 finalImpl cipher

foreign import createCipherivImpl :: EffectFn3 String Buffer (Nullable Buffer) Cipher
foreign import updateImpl :: EffectFn2 Buffer Cipher Buffer
foreign import finalImpl :: EffectFn1 Cipher Buffer
