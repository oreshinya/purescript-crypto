module Node.Crypto.Cipher
  ( Cipher
  , hex
  , base64
  , createCipher
  , update
  , final
  ) where

import Prelude

import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Effect (Effect)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, Ciphertext, Password, Plaintext)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Prim.TypeError (class Warn, Text)

foreign import data Cipher :: Type

-- | Encrypt a UTF-8 encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | Output: hex encoded `Ciphertext` and optional Node.Buffer `AuthTag`
hex ::
  Algorithm ->
  Password ->
  Plaintext ->
  Effect Ciphertext
hex alg password value = cipher alg password value Hex

-- | Encrypt a UTF-8 encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | Output: base64 encoded `Ciphertext` and optional Node.Buffer `AuthTag`
base64 ::
  Algorithm ->
  Password ->
  Plaintext ->
  Effect Ciphertext
base64 alg password value = cipher alg password value Base64

cipher ::
  Algorithm ->
  Password ->
  Plaintext ->
  Encoding ->
  Effect Ciphertext
cipher alg password value enc = do
  buf <- fromString value UTF8
  cip <- createCipher alg password
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString enc rbuf


update :: Cipher -> Buffer -> Effect Buffer
update = runEffectFn2 _update

foreign import _update :: EffectFn2 Cipher Buffer Buffer


final :: Cipher -> Effect Buffer
final = runEffectFn1 _final

foreign import _final :: EffectFn1 Cipher Buffer


createCipher :: Warn (Text "This method is deprecated and will be removed in the future. Please use cipherIv.") => Algorithm -> Password -> Effect Cipher
createCipher alg password = runEffectFn2 _createCipher (show alg) password

foreign import _createCipher :: EffectFn2 String String Cipher
