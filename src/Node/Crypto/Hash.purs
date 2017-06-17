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
import Control.Monad.Eff (Eff)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, BUFFER, fromString, toString)
import Node.Crypto (CRYPTO)



foreign import data Hash :: Type

data Algorithm
  = MD5
  | SHA512



instance showAlgorithm :: Show Algorithm where
  show MD5 = "md5"
  show SHA512 = "sha512"



hex :: forall e.
       Algorithm ->
       String ->
       Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hex alg str = hash alg str Hex



base64 :: forall e.
          Algorithm ->
          String ->
          Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
base64 alg str = hash alg str Base64



hash :: forall e.
        Algorithm ->
        String ->
        Encoding ->
        Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hash alg str enc = do
  buf <- fromString str UTF8
  createHash alg >>= flip update buf >>= digest >>= toString enc



createHash :: forall e. Algorithm -> Eff (crypto :: CRYPTO | e) Hash
createHash alg = _createHash $ show alg



foreign import _createHash :: forall e. String -> Eff (crypto :: CRYPTO | e) Hash



foreign import update :: forall e. Hash -> Buffer -> Eff (crypto :: CRYPTO | e) Hash



foreign import digest :: forall e. Hash -> Eff (crypto :: CRYPTO | e) Buffer
