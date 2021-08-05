module Node.Crypto.Hmac
  ( Hmac
  , hex
  , base64
  , createHmac
  , update
  , digest
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer, fromString, toString)
import Node.Crypto.Hash (Algorithm)
import Node.Crypto.Types (Key)
import Node.Encoding (Encoding(UTF8, Hex, Base64))

foreign import data Hmac :: Type

hex
  :: Algorithm
  -> Key
  -> String
  -> Effect String
hex alg key str = hmac alg key str Hex

base64
  :: Algorithm
  -> Key
  -> String
  -> Effect String
base64 alg key str = hmac alg key str Base64

hmac
  :: Algorithm
  -> Key
  -> String
  -> Encoding
  -> Effect String
hmac alg key str enc = do
  buf <- fromString str UTF8
  createHmac alg key >>= flip update buf >>= digest >>= toString enc

createHmac :: Algorithm -> Key -> Effect Hmac
createHmac alg key = runEffectFn2 _createHmac (show alg) key

foreign import _createHmac :: EffectFn2 String String Hmac


update :: Hmac -> Buffer -> Effect Hmac
update = runEffectFn2 _update

foreign import _update :: EffectFn2 Hmac Buffer Hmac


digest :: Hmac -> Effect Buffer 
digest = runEffectFn1 _digest

foreign import _digest :: EffectFn1 Hmac Buffer
