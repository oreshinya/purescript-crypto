module Node.Crypto.Decipher
  ( Decipher
  , fromHex
  , fromBase64
  , createDecipher
  , setAuthTag
  , update
  , final
  ) where

import Prelude
import Effect (Effect)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, InitializationVector(..), Password(..), AuthTag)
import Data.Function.Uncurried (Fn2, runFn2, Fn3, runFn3)

foreign import data Decipher :: Type

fromHex
  :: Algorithm
  -> Password
  -> String
  -> Effect String
fromHex alg password str = decipher alg password str Hex

fromBase64
  :: Algorithm
  -> Password
  -> String
  -> Effect String
fromBase64 alg password str = decipher alg password str Base64

decipher
  :: Algorithm
  -> Password
  -> String
  -> Encoding
  -> Effect String
decipher alg password str enc = do
  buf <- fromString str enc
  dec <- createDecipher alg password
  rbuf1 <- update dec buf
  rbuf2 <- final dec
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString UTF8 rbuf

foreign import _setAuthTag :: Fn2 Decipher AuthTag (Effect Unit)

setAuthTag :: Decipher -> AuthTag -> Effect Unit
setAuthTag = runFn2 _setAuthTag

createDecipher :: Algorithm -> Password -> Effect Decipher
createDecipher alg (Password password) = runFn2 _createDecipher (show alg) password

foreign import _createDecipher :: Fn2 String String (Effect Decipher)

createDecipherIv :: Algorithm -> Password -> InitializationVector -> Effect Decipher
createDecipherIv alg (Password password) (InitializationVector iv )= runFn3 _createDecipherIv (show alg) password iv

foreign import _createDecipherIv :: Fn3 String String String (Effect Decipher)

foreign import _update :: Fn2 Decipher Buffer (Effect Buffer)

update :: Decipher -> Buffer -> Effect Buffer
update = runFn2 _update

foreign import final :: Decipher -> Effect Buffer
