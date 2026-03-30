import Base64
import Base64Test.Assertions

namespace EncodeTests

def testEncodeEmpty : IO Unit := do
  Base64.encode ByteArray.empty |> shouldEqual ""

def testEncodeRfc4648Vectors : IO Unit := do
  Base64.encodeString "" |> shouldEqual ""
  Base64.encodeString "f" |> shouldEqual "Zg=="
  Base64.encodeString "fo" |> shouldEqual "Zm8="
  Base64.encodeString "foo" |> shouldEqual "Zm9v"
  Base64.encodeString "foob" |> shouldEqual "Zm9vYg=="
  Base64.encodeString "fooba" |> shouldEqual "Zm9vYmE="
  Base64.encodeString "foobar" |> shouldEqual "Zm9vYmFy"

def testEncodeCredentials : IO Unit := do
  Base64.encodeString "user:password" |> shouldEqual "dXNlcjpwYXNzd29yZA=="
  Base64.encodeString "Aladdin:open sesame" |> shouldEqual "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="

def testEncodeBinaryData : IO Unit := do
  let bytes := ByteArray.mk #[0, 1, 2, 255, 254, 253]
  let encoded := Base64.encode bytes
  Assert (!encoded.isEmpty) "Binary data encodes to non-empty"

def testEncodeUrlSafe : IO Unit := do
  -- URL-safe should replace +/ with -_ and strip padding
  Base64.encodeString "f" |> shouldEqual "Zg=="
  Base64.encodeUrl "f".toUTF8 |> shouldEqual "Zg"
  -- Bytes that produce + and / in standard encoding
  let bytes := ByteArray.mk #[0x3b, 0xb7, 0x3f]
  let std := Base64.encode bytes
  let url := Base64.encodeUrl bytes
  Assert (!url.any (· == '=')) "URL-safe has no padding"
  Assert (!url.any (· == '+')) "URL-safe has no +"
  Assert (!url.any (· == '/')) "URL-safe has no /"
  Assert (std.length >= url.length) "URL-safe is no longer than standard"

def testEncodeUrlJwtPayload : IO Unit := do
  let header := "{\"typ\":\"JWT\",\"alg\":\"RS256\"}"
  let encoded := Base64.encodeUrl header.toUTF8
  Assert (!encoded.any (· == '=')) "JWT header has no padding"
  Assert (!encoded.any (· == '+')) "JWT header has no +"
  Assert (!encoded.any (· == '/')) "JWT header has no /"

def allTests : List (String × IO Unit) :=
  [ ("encode: empty input", testEncodeEmpty)
  , ("encode: RFC 4648 test vectors", testEncodeRfc4648Vectors)
  , ("encode: credentials", testEncodeCredentials)
  , ("encode: binary data", testEncodeBinaryData)
  , ("encodeUrl: URL-safe encoding", testEncodeUrlSafe)
  , ("encodeUrl: JWT payload", testEncodeUrlJwtPayload) ]

end EncodeTests
