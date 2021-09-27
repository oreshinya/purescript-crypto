module Node.Crypto.Decipher
  ( Decipher
  , createDecipheriv
  , update
  , final
  ) where

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Node.Buffer (Buffer)

-- | [https://nodejs.org/api/crypto.html#crypto_class_decipher](https://nodejs.org/api/crypto.html#crypto_class_decipher)
-- |
-- | Usage:
-- |
-- | ```
-- | buf <- Buffer.fromString "434cf3b56614fc8eb186ea866fbd33b4" Hex
-- | pbuf <- Buffer.fromString "password" UTF8
-- | sbuf <- Buffer.fromString "salt" UTF8
-- | key <- Crypto.scryptSync pbuf sbuf 32
-- | iv <- Buffer.fromString "iviviviviviviviv" UTF8
-- | dec <- Decipher.createDecipheriv "aes256" key (Just iv)
-- | rbuf1 <- Decipher.update buf dec
-- | rbuf2 <- Decipher.final dec
-- | Buffer.concat [ rbuf1, rbuf2 ] >>= Buffer.toString UTF8
-- | ```
foreign import data Decipher :: Type

createDecipheriv :: String -> Buffer -> Maybe Buffer -> Effect Decipher
createDecipheriv alg key iv =
  runEffectFn3 createDecipherivImpl alg key (toNullable iv)

update :: Buffer -> Decipher -> Effect Buffer
update buf decipher = runEffectFn2 updateImpl buf decipher

final :: Decipher -> Effect Buffer
final decipher = runEffectFn1 finalImpl decipher

foreign import createDecipherivImpl :: EffectFn3 String Buffer (Nullable Buffer) Decipher
foreign import updateImpl :: EffectFn2 Buffer Decipher Buffer
foreign import finalImpl :: EffectFn1 Decipher Buffer
