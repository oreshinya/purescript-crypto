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
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer, fromString, toString)
import Node.Encoding (Encoding(UTF8, Hex, Base64))

foreign import data Hash :: Type

data Algorithm
  = MD5
  | SHA256
  | SHA512
  | SHA1

instance showAlgorithm :: Show Algorithm where
  show MD5 = "md5"
  show SHA256 = "sha256"
  show SHA512 = "sha512"
  show SHA1 = "sha1"

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
createHash alg = runEffectFn1 _createHash $ show alg

foreign import _createHash :: EffectFn1 String Hash


update :: Hash -> Buffer -> Effect Hash 
update = runEffectFn2 _update

foreign import _update :: EffectFn2 Hash Buffer Hash


digest :: Hash -> Effect Buffer 
digest = runEffectFn1 _digest

foreign import _digest :: EffectFn1 Hash Buffer
