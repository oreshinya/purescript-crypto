module Node.Crypto.Cipher
  ( Cipher
  , Algorithm(..)
  , Password
  , hex
  , base64
  , createCipher
  , update
  , final
  ) where

import Prelude
import Effect (Effect)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, fromString, toString, concat)



foreign import data Cipher :: Type

data Algorithm
  = AES128
  | AES192
  | AES256

type Password = String



instance showAlgorithm :: Show Algorithm where
  show AES128 = "aes128"
  show AES192 = "aes192"
  show AES256 = "aes256"



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
createCipher alg password = _createCipher (show alg) password



foreign import _createCipher
  :: String
  -> String
  -> Effect Cipher



foreign import update :: Cipher -> Buffer -> Effect Buffer



foreign import final :: Cipher -> Effect Buffer
