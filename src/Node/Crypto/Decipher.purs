module Node.Crypto.Decipher
  ( Decipher
  , fromHex
  , fromBase64
  , createDecipher
  , update
  , final
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Node.Encoding (Encoding(UTF8, Hex, Base64))
import Node.Buffer (Buffer, BUFFER, fromString, toString)
import Node.Crypto (CRYPTO)
import Node.Crypto.Cipher (Algorithm)



foreign import data Decipher :: Type



fromHex :: forall e.
           Algorithm ->
           String ->
           String ->
           Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
fromHex alg password str = decipher alg password str Hex



fromBase64 :: forall e.
              Algorithm ->
              String ->
              String ->
              Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
fromBase64 alg password str = decipher alg password str Base64



decipher :: forall e.
            Algorithm ->
            String ->
            String ->
            Encoding ->
            Eff (buffer :: BUFFER, crypto :: CRYPTO | e) String
decipher alg password str enc = do
  buf <- fromString str enc
  dec <- createDecipher alg password
  rbuf <- update dec buf
  rbuf' <- final dec
  r <- toString UTF8 rbuf
  r' <- toString UTF8 rbuf'
  pure $ r <> r'



createDecipher :: forall e. Algorithm -> String -> Eff (crypto :: CRYPTO | e) Decipher
createDecipher alg password = _createDecipher (show alg) password



foreign import _createDecipher :: forall e.
                                  String ->
                                  String ->
                                  Eff (crypto :: CRYPTO | e) Decipher



foreign import update :: forall e. Decipher -> Buffer -> Eff (crypto :: CRYPTO | e) Buffer



foreign import final :: forall e. Decipher -> Eff (crypto :: CRYPTO | e) Buffer
