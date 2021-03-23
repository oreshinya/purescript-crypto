module Node.Crypto.Cipher
  ( Cipher
  , hex
  , base64
  , createCipher
  , toIv
  , hexIv
  , base64Iv
  , createCipherIv
  , getAuthTag
  , update
  , final
  ) where

import Prelude
import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)
import Effect (Effect)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm(..), IvAlgorithm(..), AuthTag, InitializationVector(..), Password(..), Key(..), Plaintext(..), Ciphertext(..))
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Crypto.Types as Types

foreign import data Cipher :: Type

type IvCipherResult
  = { ciphertext :: Ciphertext
    , authTag :: AuthTag
    }

hex ::
  Algorithm ->
  Password ->
  String ->
  Effect String
hex alg password value = cipher alg password value Hex

base64 ::
  Algorithm ->
  Password ->
  String ->
  Effect String
base64 alg password value = cipher alg password value Base64

hexIv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  Plaintext ->
  Effect IvCipherResult
hexIv alg password iv value = toIv alg password iv value Hex

base64Iv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  Plaintext ->
  Effect IvCipherResult
base64Iv alg password iv value = toIv alg password iv value Base64

toIv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  Plaintext ->
  Encoding ->
  Effect IvCipherResult
toIv ivAlgo password iv value enc = cipherIv ivAlgo password iv value enc

cipher ::
  Algorithm ->
  Password ->
  String ->
  Encoding ->
  Effect String
cipher alg password value enc = do
  buf <- fromString value UTF8
  cip <- createCipher alg password
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString enc rbuf

cipherIv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  Plaintext ->
  Encoding ->
  Effect IvCipherResult
cipherIv alg key iv (Plaintext value) enc = do
  buf <- fromString value UTF8
  cip <- createCipherIv alg key iv
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  tag <- getAuthTag cip
  res <- toString enc rbuf
  pure $ { authTag: tag, ciphertext: (Ciphertext res) }

createCipher :: Algorithm -> Password -> Effect Cipher
createCipher alg (Password password) = runFn2 _createCipher (show alg) password

foreign import _createCipher ::
  Fn2 String String (Effect Cipher)

createCipherIv :: IvAlgorithm -> Key -> InitializationVector -> Effect Cipher
createCipherIv alg (Key key) (InitializationVector iv) = runFn3 _createCipherIv (show alg) key iv

foreign import _createCipherIv ::
  Fn3 String String String (Effect Cipher)

foreign import getAuthTag :: Cipher -> Effect AuthTag

foreign import _update :: Fn2 Cipher Buffer (Effect Buffer)

update :: Cipher -> Buffer -> (Effect Buffer)
update ciph buffer = runFn2 _update ciph buffer

foreign import final :: Cipher -> Effect Buffer
