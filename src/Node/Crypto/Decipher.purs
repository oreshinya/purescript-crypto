module Node.Crypto.Decipher
  ( Decipher
  , fromHex
  , fromBase64
  , createDecipher
  , fromIv
  , fromHexIv
  , fromBase64Iv
  , createDecipherIv
  , setAuthTag
  , update
  , final
  ) where

import Prelude
import Effect (Effect)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, fromString, toString, concat)
import Node.Crypto.Types (Algorithm, AuthTag, Ciphertext(..), InitializationVector(..), IvAlgorithm, Key(..), Password(..), Plaintext(..))
import Data.Function.Uncurried (Fn2, runFn2, Fn3, runFn3)

foreign import data Decipher :: Type

fromHex ::
  Algorithm ->
  Password ->
  String ->
  Effect String
fromHex alg password value = decipher alg password value Hex

fromBase64 ::
  Algorithm ->
  Password ->
  String ->
  Effect String
fromBase64 alg password value = decipher alg password value Base64

decipher ::
  Algorithm ->
  Password ->
  String ->
  Encoding ->
  Effect String
decipher alg password value enc = do
  buf <- fromString value enc
  dec <- createDecipher alg password
  rbuf1 <- update dec buf
  rbuf2 <- final dec
  rbuf <- concat [ rbuf1, rbuf2 ]
  toString UTF8 rbuf

fromHexIv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  AuthTag ->
  Ciphertext ->
  Effect Plaintext
fromHexIv alg key iv tag value = fromIv alg key iv tag value Hex

fromBase64Iv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  AuthTag ->
  Ciphertext ->
  Effect Plaintext
fromBase64Iv alg key iv tag value = fromIv alg key iv tag value Base64

fromIv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  AuthTag ->
  Ciphertext ->
  Encoding ->
  Effect Plaintext
fromIv ivAlg key iv tag value enc = decipherIv ivAlg key iv tag value enc

decipherIv ::
  IvAlgorithm ->
  Key ->
  InitializationVector ->
  AuthTag ->
  Ciphertext ->
  Encoding ->
  Effect Plaintext
decipherIv alg key iv tag (Ciphertext value) enc = do
  buf <- fromString value enc
  dec <- createDecipherIv alg key iv
  _ <- setAuthTag dec tag
  rbuf1 <- update dec buf
  rbuf2 <- final dec
  rbuf <- concat [ rbuf1, rbuf2 ]
  ptxt <- toString UTF8 rbuf
  pure $ Plaintext ptxt

foreign import _setAuthTag :: Fn2 Decipher AuthTag (Effect Unit)

setAuthTag :: Decipher -> AuthTag -> Effect Unit
setAuthTag = runFn2 _setAuthTag

createDecipher :: Algorithm -> Password -> Effect Decipher
createDecipher alg (Password password) = runFn2 _createDecipher (show alg) password

foreign import _createDecipher :: Fn2 String String (Effect Decipher)

createDecipherIv :: IvAlgorithm -> Key -> InitializationVector -> Effect Decipher
createDecipherIv alg (Key key) (InitializationVector iv) = runFn3 _createDecipherIv (show alg) key iv

foreign import _createDecipherIv :: Fn3 String String String (Effect Decipher)

update :: Decipher -> Buffer -> Effect Buffer
update = runFn2 _update

foreign import _update :: Fn2 Decipher Buffer (Effect Buffer)

foreign import final :: Decipher -> Effect Buffer
