module Node.Crypto.Hmac
  ( Hmac
  , Secret
  , hex
  , base64
  , createHmac
  , update
  , digest
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, BUFFER, fromString, toString)
import Node.Crypto (CRYPTO)
import Node.Crypto.Hash (Algorithm)



foreign import data Hmac :: Type

type Secret = String



hex :: forall e.
       Algorithm ->
       Secret ->
       String ->
       Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hex alg secret str = hmac alg secret str Hex



base64 :: forall e.
          Algorithm ->
          Secret ->
          String ->
          Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
base64 alg secret str = hmac alg secret str Base64



hmac :: forall e.
        Algorithm ->
        Secret ->
        String ->
        Encoding ->
        Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
hmac alg secret str enc = do
  buf <- fromString str UTF8
  createHmac alg secret >>= flip update buf >>= digest >>= toString enc



createHmac :: forall e. Algorithm -> Secret -> Eff (crypto :: CRYPTO | e) Hmac
createHmac alg secret = _createHmac (show alg) secret



foreign import _createHmac :: forall e. String -> String -> Eff (crypto :: CRYPTO | e) Hmac



foreign import update :: forall e. Hmac -> Buffer -> Eff (crypto :: CRYPTO | e) Hmac



foreign import digest :: forall e. Hmac -> Eff (crypto :: CRYPTO | e) Buffer
