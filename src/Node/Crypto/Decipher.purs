module Node.Crypto.Decipher
  ( Decipher
  , fromHex
  , fromBase64
  , createDecipher
  , update
  , final
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, Ciphertext, Password, Plaintext)
import Node.Encoding (Encoding(..))
import Prim.TypeError (class Warn, Text)

foreign import data Decipher :: Type

-- | Decrypt a hex-encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | The AuthTag however is a `Node.Buffer`, which is returned by `getAuthTag` of the js crypto library
-- | Output: UTF-8 encoded `Plaintext`
fromHex ::
  Algorithm ->
  Password ->
  Ciphertext ->
  Effect Plaintext
fromHex alg password value = decipher alg password value Hex

-- | Decrypt a base64-encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | The AuthTag however is a `Node.Buffer`, which is returned by `getAuthTag` of the js crypto library
-- | Output: UTF-8 encoded `Plaintext`
fromBase64 ::
  Algorithm ->
  Password ->
  Ciphertext ->
  Effect Plaintext
fromBase64 alg password value = decipher alg password value Base64

decipher ::
  Algorithm ->
  Password ->
  Ciphertext ->
  Encoding ->
  Effect Plaintext
decipher alg password value enc = do
  buf <- fromString value enc
  dec <- createDecipher alg password
  rbuf1 <- update dec buf
  rbuf2 <- final dec
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString UTF8 rbuf


update :: Decipher -> Buffer -> Effect Buffer
update = runEffectFn2 _update

foreign import _update :: EffectFn2 Decipher Buffer Buffer


final :: Decipher -> Effect Buffer
final = runEffectFn1 _final

foreign import _final :: EffectFn1 Decipher Buffer


createDecipher :: Warn (Text "This method is deprecated and will be removed in the future. Please use createDecipherIv.") => Algorithm -> Password -> Effect Decipher
createDecipher alg password = runEffectFn2 _createDecipher (show alg) password

foreign import _createDecipher :: EffectFn2 String String Decipher