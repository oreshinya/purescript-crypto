module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Node.Crypto as Crypto
import Node.Crypto.Cipher as Cipher
import Node.Crypto.CipherIv as CipherIv
import Node.Crypto.Decipher as Decipher
import Node.Crypto.DecipherIv as DecipherIv
import Node.Crypto.Hash as Hash
import Node.Crypto.Hmac as Hmac
import Node.Crypto.Types as Types
import Test.Assert (assert)

main :: Effect Unit
main = do
  hexHash :: String <- Hash.hex Hash.SHA512 "sample_password"
  hexHmac <- Hmac.hex Hash.SHA512 secret "sample_password"
  hexCipher <- CipherIv.hex Types.AES256 key (Just iv) sample_plaintext
  fromHexDecipher <- DecipherIv.fromHex Types.AES256 key (Just iv) Nothing hexCipher.ciphertext
  base64Hash <- Hash.base64 Hash.SHA512 "sample_password"
  base64Hmac <- Hmac.base64 Hash.SHA512 secret "sample_password"
  base64Cipher <- Cipher.base64 Types.AES256 password identifier
  fromBase64Decipher <- Decipher.fromBase64 Types.AES256 password base64Cipher
  base64CipherIv <- CipherIv.base64 Types.AES256 key (Just iv) sample_plaintext
  fromBase64DecipherIv <- DecipherIv.fromBase64 Types.AES256 key (Just iv) Nothing base64CipherIv.ciphertext
  base64CipherIvGcm <- CipherIv.base64 (Types.WithAuth Types.AES256GCM) key (Just iv) sample_plaintext
  fromBase64DecipherIvGcm <- DecipherIv.fromBase64 (Types.WithAuth Types.AES256GCM) key (Just iv) (base64CipherIvGcm.authTag) (base64CipherIvGcm.ciphertext)
  assert $ hexHash == "fd369c76561c41e90eaacef9e95dde1b92a402980b75d739da368ad427e2a5a01bc79e5a6fb46df001b8e21c94e702bfb47574271e4098150854e112bb9c9d1d"
  assert $ hexHmac == "64ca657263492b718984ab0a4a5a2a43288c35d9e15c6797f2597ce8e8440e862c5495cf852f4044e6caa9fe58bf0972153fcb827a5581d06e72b404126dbf05"
  assert $ hexCipher.ciphertext == "cf4e5bb9d709c6e62267870b52ca691d67b14ba4aeb3b0127c24aadaf4d73eb2"
  assert $ fromHexDecipher == sample_plaintext
  assert $ base64Hash == "/TacdlYcQekOqs756V3eG5KkApgLddc52jaK1CfipaAbx55ab7Rt8AG44hyU5wK/tHV0Jx5AmBUIVOESu5ydHQ=="
  assert $ base64Hmac == "ZMplcmNJK3GJhKsKSloqQyiMNdnhXGeX8ll86OhEDoYsVJXPhS9ARObKqf5YvwlyFT/LgnpVgdBucrQEEm2/BQ=="
  assert $ base64Cipher == "+iextYmjw5V2yc7P5QcWgoFdpUP7znXEgjpr5w8OF3c="
  assert $ fromBase64Decipher == identifier
  assert $ base64CipherIv.ciphertext == "z05budcJxuYiZ4cLUsppHWexS6Sus7ASfCSq2vTXPrI="
  assert $ fromBase64DecipherIv == sample_plaintext
  assert $ base64CipherIvGcm.ciphertext == "JdPl26+0QxWYxPyK5tT5+w=="
  assert $ fromBase64DecipherIvGcm == sample_plaintext
  assert =<< Crypto.timingSafeEqualString "127e6fbfe24a750e72930c" "127e6fbfe24a750e72930c"

identifier :: String
identifier = "sample_identifier"

sample_plaintext :: Types.Plaintext
sample_plaintext = "sample_plaintext"

iv :: Types.InitializationVector
iv = (Types.IvString "1234567890123456")

password :: Types.Password
password = "sample_password"

key :: Types.Key
key = "12345678901234567890123456789012"

secret :: Types.Key
secret = "sample_secret"