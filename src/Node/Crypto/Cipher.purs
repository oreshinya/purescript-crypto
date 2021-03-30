module Node.Crypto.Cipher
  ( Cipher
  , hex
  , base64
  , createCipher
  , createCipherIv
  , getAuthTag
  , update
  , final
  ) where

import Prelude

import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Nullable (Nullable, toNullable)
import Data.Traversable (sequence)
import Effect (Effect)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm(..), AuthTag(..), Ciphertext(..), InitializationVector(..), Key(..), Password(..), Plaintext(..))
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Prim.TypeError (class Warn, Text)

foreign import data Cipher :: Type

type CipherResult
  = { ciphertext :: Ciphertext
    , authTag :: Maybe AuthTag
    }

-- | Encrypt a UTF-8 encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | Output: hex encoded `Ciphertext` and optional Node.Buffer `AuthTag`
hex ::
  Algorithm ->
  Key ->
  Maybe InitializationVector ->
  Plaintext ->
  Effect CipherResult
hex alg password iv value = cipherIv alg password iv value Hex

-- | Encrypt a UTF-8 encoded ciphertext
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | Output: base64 encoded `Ciphertext` and optional Node.Buffer `AuthTag`
base64 ::
  Algorithm ->
  Key ->
  Maybe InitializationVector ->
  Plaintext ->
  Effect CipherResult
base64 alg password iv value = cipherIv alg password iv value Base64

cipherIv ::
  Algorithm ->
  Key ->
  Maybe InitializationVector ->
  Plaintext ->
  Encoding ->
  Effect CipherResult
cipherIv alg key iv (Plaintext value) enc = do
  buf <- fromString value UTF8
  cip <- createCipherIv alg key iv
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  tag <- sequence $ case alg of 
    WithAuth _ -> Just $ getAuthTag cip
    _ -> Nothing
  res <- toString enc rbuf
  pure $ { authTag: tag, ciphertext: (Ciphertext res) }

-- | Provides a Cipher
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | Output: base64 encoded `Ciphertext` and optional Node.Buffer `AuthTag`
createCipherIv :: Algorithm -> Key -> Maybe InitializationVector -> Effect Cipher
createCipherIv alg (Key key) maybeIV = runFn3 _createCipherIv (show alg) key iv 
  where
    iv = maybeIV <#> (un InitializationVector) # toNullable

foreign import _createCipherIv ::
  Fn3 String String (Nullable String) (Effect Cipher)

foreign import _getAuthTag :: Cipher -> Effect Buffer

getAuthTag :: Cipher -> Effect AuthTag
getAuthTag c = _getAuthTag c <#> AuthTag

foreign import _update :: Fn2 Cipher Buffer (Effect Buffer)

update :: Cipher -> Buffer -> (Effect Buffer)
update ciph buffer = runFn2 _update ciph buffer

foreign import final :: Cipher -> Effect Buffer

createCipher :: Warn (Text "This method is deprecated and will be removed in the future. Please use cipherIv.") => Algorithm -> Password -> Effect Cipher
createCipher alg (Password password) = runFn2 _createCipher (show alg) password

foreign import _createCipher ::
  Fn2 String String (Effect Cipher)