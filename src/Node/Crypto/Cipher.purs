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
import Control.Monad.Eff (Eff)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, BUFFER, fromString, toString, concat)
import Node.Crypto (CRYPTO)



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
  :: forall e
   . Algorithm
  -> Password
  -> String
  -> Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hex alg password str = cipher alg password str Hex



base64
  :: forall e
   . Algorithm
  -> Password
  -> String
  -> Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
base64 alg password str = cipher alg password str Base64



cipher
  :: forall e
   . Algorithm
  -> Password
  -> String
  -> Encoding
  -> Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
cipher alg password str enc = do
  buf <- fromString str UTF8
  cip <- createCipher alg password
  rbuf1 <- update cip buf
  rbuf2 <- final cip
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString enc rbuf



createCipher :: forall e. Algorithm -> Password -> Eff (crypto :: CRYPTO | e) Cipher
createCipher alg password = _createCipher (show alg) password



foreign import _createCipher
  :: forall e
   . String
  -> String
  -> Eff (crypto :: CRYPTO | e) Cipher



foreign import update :: forall e. Cipher -> Buffer -> Eff (crypto :: CRYPTO | e) Buffer



foreign import final :: forall e. Cipher -> Eff (crypto :: CRYPTO | e) Buffer
