module Node.Crypto.Hmac
  ( Hmac
  , Secret(..)
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
import Data.Newtype (class Newtype)
import Data.Function.Uncurried (Fn2, runFn2)

foreign import data Hmac :: Type

newtype Secret = Secret String
instance ntSecret :: Newtype Secret String

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
createHmac alg (Secret secret) = runFn2 _createHmac (show alg) secret

foreign import _createHmac :: Fn2 String String (Effect Hmac)

foreign import _update :: Fn2 Hmac Buffer (Effect Hmac)

update :: Hmac -> Buffer -> Effect Hmac
update = runFn2 _update

foreign import digest :: Hmac -> Effect Buffer
