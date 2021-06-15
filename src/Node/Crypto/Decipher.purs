module Node.Crypto.Decipher
  ( Decipher
  , fromHex
  , fromBase64
  , createDecipher
  , createDecipherIv
  , setAuthTag
  , update
  , final
  ) where

import Prelude

import Data.Function.Uncurried (Fn2, runFn2, Fn3, runFn3)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Nullable (Nullable, toNullable)
import Data.Traversable (traverse)
import Effect (Effect)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, AuthTag, Ciphertext(..), InitializationVector(..), Key(..), Password(..), Plaintext(..))
import Node.Encoding (Encoding(..))
import Prim.TypeError (class Warn, Text)

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
decipherIv alg (Key key) ivM tag (Ciphertext value) enc = do
  buf <- fromString value enc
  skey <- fromString key UTF8
  biv <- traverse (\iv -> fromString (un InitializationVector iv) UTF8) ivM
  dec <- createDecipherIv alg skey (toNullable biv)
  _ <- case tag of 
    Just t -> setAuthTag dec t
    _ -> pure unit
  rbuf1 <- update dec buf
  rbuf2 <- final dec
  rbuf <- concat [ rbuf1, rbuf2 ]
  ptxt <- toString UTF8 rbuf
  pure $ Plaintext ptxt

foreign import _setAuthTag :: Fn2 Decipher AuthTag (Effect Unit)

setAuthTag :: Decipher -> AuthTag -> Effect Unit
setAuthTag = runFn2 _setAuthTag

-- | Provides a Decipher
-- | Make sure that the key and the initialization vector are Node.Buffer
-- | The AuthTag however is a Node.Buffer, which is returned by `getAuthTag` of the js crypto library
-- | Output: UTF-8 encoded Plaintext
createDecipherIv :: Algorithm -> Buffer -> Nullable Buffer -> Effect Decipher
createDecipherIv alg key iv = runFn3 _createDecipherIv (show alg) key iv

foreign import _createDecipherIv :: Fn3 String Buffer (Nullable Buffer) (Effect Decipher)

update :: Decipher -> Buffer -> Effect Buffer
update = runFn2 _update

foreign import _update :: Fn2 Decipher Buffer (Effect Buffer)

foreign import final :: Decipher -> Effect Buffer

createDecipher :: Warn (Text "This method is deprecated and will be removed in the future. Please use createDecipherIv.") => Algorithm -> Password -> Effect Decipher
createDecipher alg (Password password) = runFn2 _createDecipher (show alg) password

foreign import _createDecipher :: Fn2 String String (Effect Decipher)