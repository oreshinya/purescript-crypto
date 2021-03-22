module Node.Crypto.Cipher
  ( Cipher
  , hex
  , base64
  , createCipher
  , update
  , final
  ) where

import Prelude

import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)
import Effect (Effect)
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, AuthTag, InitializationVector(..), Password(..))
import Node.Encoding (Encoding(UTF8, Hex, Base64))

foreign import data Cipher :: Type

hex
  :: Algorithm
  -> Password
  -> String
  -> Effect String
hex alg password str = cipher alg password str Hex

base64
  :: Algorithm
  -> Password
  -> String
  -> Effect String
base64 alg password str = cipher alg password str Base64

cipher
  :: Algorithm
  -> Password
  -> String
  -> Encoding
  -> Effect String
cipher alg password str enc = do
  buf <- fromString str UTF8
  cip <- createCipher alg password
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString enc rbuf

createCipher :: Algorithm -> Password -> Effect Cipher
createCipher alg (Password password) = runFn2 _createCipher (show alg) password

foreign import _createCipher
  :: Fn2 String String (Effect Cipher)

createCipherIv :: Algorithm -> Password -> InitializationVector -> Effect Cipher
createCipherIv alg (Password password) (InitializationVector iv) = runFn3 _createCipherIv (show alg) password iv

foreign import _createCipherIv
  :: Fn3 String String String (Effect Cipher)

foreign import getAuthTag :: Cipher -> Effect AuthTag

foreign import _update :: Fn2 Cipher Buffer (Effect Buffer)

update :: Cipher -> Buffer -> (Effect Buffer)
update ciph buffer = runFn2 _update ciph buffer

foreign import final :: Cipher -> Effect Buffer
