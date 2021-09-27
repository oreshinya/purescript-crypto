module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Node.Buffer as Buffer
import Node.Crypto (scrypt, scryptSync)
import Node.Crypto.Cipher as Cipher
import Node.Crypto.Decipher as Decipher
import Node.Crypto.Hash as Hash
import Node.Crypto.Hmac as Hmac
import Node.Encoding (Encoding(..))
import Test.Unit (test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  test "hash" do
    result <- liftEffect do
      buf <- Buffer.fromString "dummy" UTF8
      Hash.createHash "sha512" >>= Hash.update buf >>= Hash.digest >>= Buffer.toString Hex
    Assert.equal "1692526aab84461a8aebcefddcba2b33fb5897ab180c53e8b345ae125484d0aaa35baf60487050be21ed8909a48eace93851bf139087ce1f7a87d97b6120a651" result

  test "hmac" do
    result <- liftEffect do
      buf <- Buffer.fromString "dummy" UTF8
      key <- Buffer.fromString "key" UTF8
      Hmac.createHmac "sha512" key >>= Hmac.update buf >>= Hmac.digest >>= Buffer.toString Hex
    Assert.equal "6462a852889cebcd98c27bc81d69fd46b2f7ea83fc4210f4eab29f8d4a4cc0a385ce2ecf280def0680f36bb668c866120964444eea0d377f0459ecb91fea52ad" result

  test "cipher" do
    result <- liftEffect do
      buf <- Buffer.fromString "dummy" UTF8
      pbuf <- Buffer.fromString "password" UTF8
      sbuf <- Buffer.fromString "salt" UTF8
      key <- scryptSync pbuf sbuf 32
      iv <- Buffer.fromString "iviviviviviviviv" UTF8
      cip <- Cipher.createCipheriv "aes256" key (Just iv)
      rbuf1 <- Cipher.update buf cip
      rbuf2 <- Cipher.final cip
      Buffer.concat [ rbuf1, rbuf2 ] >>= Buffer.toString Hex
    Assert.equal "434cf3b56614fc8eb186ea866fbd33b4" result

  test "decipher" do
    result <- do
      buf <- liftEffect $ Buffer.fromString "434cf3b56614fc8eb186ea866fbd33b4" Hex
      pbuf <- liftEffect $ Buffer.fromString "password" UTF8
      sbuf <- liftEffect $ Buffer.fromString "salt" UTF8
      key <- scrypt pbuf sbuf 32
      iv <- liftEffect $ Buffer.fromString "iviviviviviviviv" UTF8
      dec <- liftEffect $ Decipher.createDecipheriv "aes256" key (Just iv)
      rbuf1 <- liftEffect $ Decipher.update buf dec
      rbuf2 <- liftEffect $ Decipher.final dec
      liftEffect $ Buffer.concat [ rbuf1, rbuf2 ] >>= Buffer.toString UTF8
    Assert.equal "dummy" result
