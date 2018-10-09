module Test.Main where

import Prelude
import Effect (Effect)
import Test.Assert (assert)
import Node.Crypto as Crypto
import Node.Crypto.Hash as Hash
import Node.Crypto.Hmac as Hmac
import Node.Crypto.Cipher as Cipher
import Node.Crypto.Decipher as Decipher



main :: Effect Unit
main = do
  hexHash <- Hash.hex Hash.SHA512 password
  hexHmac <- Hmac.hex Hash.SHA512 secret password
  hexCipher <- Cipher.hex Cipher.AES256 password identifier
  fromHexDecipher <- Decipher.fromHex Cipher.AES256 password hexCipher
  base64Hash <- Hash.base64 Hash.SHA512 password
  base64Hmac <- Hmac.base64 Hash.SHA512 secret password
  base64Cipher <- Cipher.base64 Cipher.AES256 password identifier
  fromBase64Decipher <- Decipher.fromBase64 Cipher.AES256 password base64Cipher
  assert $ hexHash == "fd369c76561c41e90eaacef9e95dde1b92a402980b75d739da368ad427e2a5a01bc79e5a6fb46df001b8e21c94e702bfb47574271e4098150854e112bb9c9d1d"
  assert $ hexHmac == "64ca657263492b718984ab0a4a5a2a43288c35d9e15c6797f2597ce8e8440e862c5495cf852f4044e6caa9fe58bf0972153fcb827a5581d06e72b404126dbf05"
  assert $ hexCipher == "fa27b1b589a3c39576c9cecfe5071682815da543fbce75c4823a6be70f0e1777"
  assert $ fromHexDecipher == identifier
  assert $ base64Hash == "/TacdlYcQekOqs756V3eG5KkApgLddc52jaK1CfipaAbx55ab7Rt8AG44hyU5wK/tHV0Jx5AmBUIVOESu5ydHQ=="
  assert $ base64Hmac == "ZMplcmNJK3GJhKsKSloqQyiMNdnhXGeX8ll86OhEDoYsVJXPhS9ARObKqf5YvwlyFT/LgnpVgdBucrQEEm2/BQ=="
  assert $ base64Cipher == "+iextYmjw5V2yc7P5QcWgoFdpUP7znXEgjpr5w8OF3c="
  assert $ fromBase64Decipher == identifier
  assert =<< Crypto.timingSafeEqualString "127e6fbfe24a750e72930c" "127e6fbfe24a750e72930c"



identifier :: String
identifier = "sample_identifier"



password :: String
password = "sample_password"



secret :: String
secret = "sample_secret"
