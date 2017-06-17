module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Test.Assert (assert, ASSERT)
import Node.Buffer (BUFFER)
import Node.Crypto (CRYPTO)
import Node.Crypto.Hash as Hash
import Node.Crypto.Hmac as Hmac



main :: forall e. Eff (assert :: ASSERT, buffer :: BUFFER, crypto :: CRYPTO | e) Unit
main = do
  hexHash <- Hash.hex Hash.SHA512 password
  hexHmac <- Hmac.hex Hash.SHA512 secret password
  base64Hash <- Hash.base64 Hash.SHA512 password
  base64Hmac <- Hmac.base64 Hash.SHA512 secret password
  assert $ hexHash == "fd369c76561c41e90eaacef9e95dde1b92a402980b75d739da368ad427e2a5a01bc79e5a6fb46df001b8e21c94e702bfb47574271e4098150854e112bb9c9d1d"
  assert $ hexHmac == "64ca657263492b718984ab0a4a5a2a43288c35d9e15c6797f2597ce8e8440e862c5495cf852f4044e6caa9fe58bf0972153fcb827a5581d06e72b404126dbf05"
  assert $ base64Hash == "/TacdlYcQekOqs756V3eG5KkApgLddc52jaK1CfipaAbx55ab7Rt8AG44hyU5wK/tHV0Jx5AmBUIVOESu5ydHQ=="
  assert $ base64Hmac == "ZMplcmNJK3GJhKsKSloqQyiMNdnhXGeX8ll86OhEDoYsVJXPhS9ARObKqf5YvwlyFT/LgnpVgdBucrQEEm2/BQ=="



password :: String
password = "sample_password"



secret :: String
secret = "sample_secret"
