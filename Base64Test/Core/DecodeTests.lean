import Base64
import Base64Test.Assertions

namespace DecodeTests

private def unwrap (opt : Option α) (msg : String) : IO α :=
  match opt with
  | some v => pure v
  | none => throw <| IO.userError s!"Expected some, got none: {msg}"

def testDecodeEmpty : IO Unit := do
  let result ← unwrap (Base64.decodeString "") "decode empty"
  result |> shouldEqual ""

def testDecodeRfc4648Vectors : IO Unit := do
  Base64.decodeString "Zg==" |> shouldBeSome "f"
  Base64.decodeString "Zm8=" |> shouldBeSome "fo"
  Base64.decodeString "Zm9v" |> shouldBeSome "foo"
  Base64.decodeString "Zm9vYg==" |> shouldBeSome "foob"
  Base64.decodeString "Zm9vYmE=" |> shouldBeSome "fooba"
  Base64.decodeString "Zm9vYmFy" |> shouldBeSome "foobar"

def testDecodeCredentials : IO Unit := do
  Base64.decodeString "dXNlcjpwYXNzd29yZA==" |> shouldBeSome "user:password"
  Base64.decodeString "QWxhZGRpbjpvcGVuIHNlc2FtZQ==" |> shouldBeSome "Aladdin:open sesame"

def testDecodeWhitespace : IO Unit := do
  Base64.decodeString "Zm9v YmFy" |> shouldBeSome "foobar"
  Base64.decodeString "Zm9v\nYmFy" |> shouldBeSome "foobar"

def testDecodeInvalid : IO Unit := do
  Base64.decodeString "!@#$" |> shouldBeNone

def testDecodeBinaryRoundtrip : IO Unit := do
  let bytes := ByteArray.mk #[0, 1, 2, 255, 254, 253]
  let encoded := Base64.encode bytes
  let decoded ← unwrap (Base64.decode encoded) "binary roundtrip"
  Assert (decoded == bytes) "Binary data preserved through roundtrip"

def testDecodeUrlSafe : IO Unit := do
  Base64.decodeString "Zg" |> shouldBeSome "f"
  let bytes := ByteArray.mk #[0x3b, 0xb7, 0x3f]
  let urlEncoded := Base64.encodeUrl bytes
  let decoded ← unwrap (Base64.decode urlEncoded) "url roundtrip"
  Assert (decoded == bytes) "URL-safe roundtrip preserves data"

def testRoundtripStrings : IO Unit := do
  let testStrings :=
    [ ""
    , "a"
    , "ab"
    , "abc"
    , "Hello, World!"
    , "The quick brown fox jumps over the lazy dog"
    , "1234567890"
    , "!@#$%^&*()_+-=[]{}|;':\",./<>?"
    , "Line1\nLine2\nLine3" ]
  testStrings.forM fun s => do
    let encoded := Base64.encodeString s
    let decoded ← unwrap (Base64.decodeString encoded) s!"roundtrip '{s.take 20}'"
    decoded |> shouldEqual s

def allTests : List (String × IO Unit) :=
  [ ("decode: empty input", testDecodeEmpty)
  , ("decode: RFC 4648 test vectors", testDecodeRfc4648Vectors)
  , ("decode: credentials", testDecodeCredentials)
  , ("decode: whitespace tolerance", testDecodeWhitespace)
  , ("decode: rejects invalid input", testDecodeInvalid)
  , ("decode: binary roundtrip", testDecodeBinaryRoundtrip)
  , ("decode: URL-safe input", testDecodeUrlSafe)
  , ("roundtrip: various strings", testRoundtripStrings) ]

end DecodeTests
