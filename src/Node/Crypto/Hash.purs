module Node.Crypto.Hash
  ( Hash
  , Algorithm(..)
  , hex
  , base64
  , createHash
  , update
  , digest
  ) where

import Prelude
import Effect (Effect)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, fromString, toString)

foreign import data Hash :: Type

data Algorithm
  = MD5
  | SHA256
  | SHA512

instance showAlgorithm :: Show Algorithm where
  show MD5 = "md5"
  show SHA256 = "sha256"
  show SHA512 = "sha512"

hex
  :: Algorithm
  -> String
  -> Effect String
hex alg str = hash alg str Hex

base64
  :: Algorithm
  -> String
  -> Effect String
base64 alg str = hash alg str Base64

hash
  :: Algorithm
  -> String
  -> Encoding
  -> Effect String
hash alg str enc = do
  buf <- fromString str UTF8
  createHash alg >>= flip update buf >>= digest >>= toString enc

createHash :: Algorithm -> Effect Hash
createHash alg = _createHash $ show alg

foreign import _createHash :: String -> Effect Hash

foreign import update :: Hash -> Buffer -> Effect Hash

foreign import digest :: Hash -> Effect Buffer
