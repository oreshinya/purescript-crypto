module Node.Crypto.DecipherIv
  ( Decipher
  , fromHex
  , fromBase64
  , createDecipherIv
  , setAuthTag
  , update
  , final
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, AuthTag, Ciphertext, InitializationVector, Key, Plaintext)
import Node.Encoding (Encoding(..))

foreign import data Decipher :: Type

-- | Decrypt a hex-encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | The AuthTag however is a `Node.Buffer`, which is returned by `getAuthTag` of the js crypto library
-- | Output: UTF-8 encoded `Plaintext`
fromHex ::
  Algorithm ->
  Key ->
  Maybe InitializationVector ->
  Maybe AuthTag ->
  Ciphertext ->
  Effect Plaintext
fromHex alg key iv tag value = decipherIv alg key iv tag value Hex

-- | Decrypt a base64-encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | The AuthTag however is a `Node.Buffer`, which is returned by `getAuthTag` of the js crypto library
-- | Output: UTF-8 encoded `Plaintext`
fromBase64 ::
  Algorithm ->
  Key ->
  Maybe InitializationVector ->
  Maybe AuthTag ->
  Ciphertext ->
  Effect Plaintext
fromBase64 alg key iv tag value = decipherIv alg key iv tag value Base64

decipherIv ::
  Algorithm ->
  Key ->
  Maybe InitializationVector ->
  Maybe AuthTag ->
  Ciphertext ->
  Encoding ->
  Effect Plaintext
decipherIv alg key ivM tag value enc = do
  buf <- fromString value enc
  skey <- fromString key UTF8
  biv <- traverse (\iv -> fromString (show iv) UTF8) ivM
  dec <- createDecipherIv alg skey (toNullable biv)
  _ <- case tag of 
    Just t -> setAuthTag dec t
    _ -> pure unit
  rbuf1 <- update dec buf
  rbuf2 <- final dec
  rbuf <- concat [ rbuf1, rbuf2 ]
  ptxt <- toString UTF8 rbuf
  pure $ ptxt


setAuthTag :: Decipher -> AuthTag -> Effect Unit
setAuthTag = runEffectFn2 _setAuthTag

foreign import _setAuthTag :: EffectFn2 Decipher AuthTag Unit


-- | Provides a Decipher
-- | Make sure that the key and the initialization vector are Node.Buffer
-- | The AuthTag however is a Node.Buffer, which is returned by `getAuthTag` of the js crypto library
-- | Output: UTF-8 encoded Plaintext
createDecipherIv :: Algorithm -> Buffer -> Nullable Buffer -> Effect Decipher
createDecipherIv alg = runEffectFn3 _createDecipherIv (show alg)

foreign import _createDecipherIv :: EffectFn3 String Buffer (Nullable Buffer) Decipher


update :: Decipher -> Buffer -> Effect Buffer
update = runEffectFn2 _update

foreign import _update :: EffectFn2 Decipher Buffer Buffer


final :: Decipher -> Effect Buffer
final = runEffectFn1 _final

foreign import _final :: EffectFn1 Decipher Buffer