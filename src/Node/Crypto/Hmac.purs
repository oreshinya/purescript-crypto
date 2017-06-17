module Node.Crypto.Hmac
  ( Hmac
  , hmac
  , createHmac
  , update
  , digest
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Node.Encoding (Encoding(UTF8))
import Node.Buffer (Buffer, BUFFER, fromString, toString)
import Node.Crypto (CRYPTO)
import Node.Crypto.Hash (Algorithm)



foreign import data Hmac :: Type



hmac :: forall e.
        Algorithm ->
        String ->
        String ->
        Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hmac alg secret str = do
  buf <- fromString str UTF8
  createHmac alg secret >>= flip update buf >>= digest >>= toString UTF8



createHmac :: forall e. Algorithm -> String -> Eff (crypto :: CRYPTO | e) Hmac
createHmac alg secret = _createHmac (show alg) secret



foreign import _createHmac :: forall e. String -> String -> Eff (crypto :: CRYPTO | e) Hmac



foreign import update :: forall e. Hmac -> Buffer -> Eff (crypto :: CRYPTO | e) Hmac



foreign import digest :: forall e. Hmac -> Eff (crypto :: CRYPTO | e) Buffer
