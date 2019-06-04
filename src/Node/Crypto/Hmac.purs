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
import Effect (Effect)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, fromString, toString)
import Node.Crypto.Hash (Algorithm)

foreign import data Hmac :: Type

type Secret = String

hex
  :: Algorithm
  -> Secret
  -> String
  -> Effect String
hex alg secret str = hmac alg secret str Hex

base64
  :: Algorithm
  -> Secret
  -> String
  -> Effect String
base64 alg secret str = hmac alg secret str Base64

hmac
  :: Algorithm
  -> Secret
  -> String
  -> Encoding
  -> Effect String
hmac alg secret str enc = do
  buf <- fromString str UTF8
  createHmac alg secret >>= flip update buf >>= digest >>= toString enc

createHmac :: Algorithm -> Secret -> Effect Hmac
createHmac alg secret = _createHmac (show alg) secret

foreign import _createHmac :: String -> String -> Effect Hmac

foreign import update :: Hmac -> Buffer -> Effect Hmac

foreign import digest :: Hmac -> Effect Buffer
