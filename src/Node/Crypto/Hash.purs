module Node.Crypto.Hash
  ( Hash
  , Algorithm(..)
  , hash
  , createHash
  , update
  , digest
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Node.Encoding (Encoding(UTF8))
import Node.Buffer (Buffer, BUFFER, fromString, toString)
import Node.Crypto (CRYPTO)



foreign import data Hash :: Type

data Algorithm
  = MD5
  | SHA512



instance showAlgorithm :: Show Algorithm where
  show MD5 = "md5"
  show SHA512 = "sha512"



hash :: forall e. Algorithm -> String -> Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hash alg str = do
  buf <- fromString str UTF8
  createHash alg >>= flip update buf >>= digest >>= toString UTF8



createHash :: forall e. Algorithm -> Eff (crypto :: CRYPTO | e) Hash
createHash alg = _createHash $ show alg



foreign import _createHash :: forall e. String -> Eff (crypto :: CRYPTO | e) Hash



foreign import update :: forall e. Hash -> Buffer -> Eff (crypto :: CRYPTO | e) Hash



foreign import digest :: forall e. Hash -> Eff (crypto :: CRYPTO | e) Buffer
