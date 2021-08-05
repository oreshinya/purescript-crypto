module Node.Crypto.CipherIv
  ( Cipher
  , hex
  , base64
  , createCipherIv
  , getAuthTag
  , update
  , final
  ) where

import Prelude

import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import Data.Traversable (sequence)
import Effect (Effect)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm(..), AuthTag, Ciphertext, InitializationVector, Key, Plaintext)
import Node.Encoding (Encoding(UTF8, Hex, Base64))

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
cipherIv alg key iv value enc = do
  buf <- fromString value UTF8
  cip <- createCipherIv alg key iv
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  tag <- sequence $ case alg of 
    WithAuth _ -> Just $ getAuthTag cip
    _ -> Nothing
  res <- toString enc rbuf
  pure $ { authTag: tag, ciphertext: res }

-- | Provides a Cipher
-- | Make sure that the key and the initialization vector is a UTF-8 encoded string
-- | Output: base64 encoded `Ciphertext` and optional Node.Buffer `AuthTag`
createCipherIv :: Algorithm -> Key -> Maybe InitializationVector -> Effect Cipher
createCipherIv alg key maybeIV = runEffectFn3 _createCipherIv (show alg) key iv 
  where
    iv = maybeIV <#> show # toNullable

foreign import _createCipherIv ::
  EffectFn3 String String (Nullable String) Cipher


getAuthTag :: Cipher -> Effect AuthTag
getAuthTag = runEffectFn1 _getAuthTag

foreign import _getAuthTag :: EffectFn1 Cipher Buffer


update :: Cipher -> Buffer -> Effect Buffer
update = runEffectFn2 _update

foreign import _update :: EffectFn2 Cipher Buffer Buffer


final :: Cipher -> Effect Buffer
final = runEffectFn1 _final

foreign import _final :: EffectFn1 Cipher Buffer