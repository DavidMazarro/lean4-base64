namespace Base64

private def charIndex (c : Char) : Option UInt8 :=
  if c >= 'A' && c <= 'Z' then some (c.toNat - 'A'.toNat).toUInt8
  else if c >= 'a' && c <= 'z' then some (c.toNat - 'a'.toNat + 26).toUInt8
  else if c >= '0' && c <= '9' then some (c.toNat - '0'.toNat + 52).toUInt8
  else if c == '+' || c == '-' then some 62
  else if c == '/' || c == '_' then some 63
  else if c == '=' then some 0
  else none

/-- Decode a Base64 string to bytes.
    Accepts both standard (`+/`) and URL-safe (`-_`) alphabets.
    Tolerates whitespace (spaces, newlines, carriage returns).
    Returns `none` on invalid input. -/
def decode (encoded : String) : Option ByteArray := do
  let chars := encoded.toList.filter fun c =>
    c != ' ' && c != '\n' && c != '\r' && c != '\t'
  if chars.isEmpty then return ByteArray.empty
  -- Pad to multiple of 4 if needed (URL-safe inputs omit padding)
  let padded :=
    let r := chars.length % 4
    if r == 0 then chars
    else chars ++ List.replicate (4 - r) '='
  if padded.length % 4 != 0 then none
  let mut result := ByteArray.empty
  let mut i := 0
  while i < padded.length do
    let c0 ← charIndex padded[i]!
    let c1 ← charIndex padded[i + 1]!
    let c2Char := padded[i + 2]!
    let c3Char := padded[i + 3]!
    let c2 ← charIndex c2Char
    let c3 ← charIndex c3Char
    result := result.push ((c0 <<< 2) ||| (c1 >>> 4))
    if c2Char != '=' then
      result := result.push (((c1 &&& 0x0F) <<< 4) ||| (c2 >>> 2))
    if c3Char != '=' then
      result := result.push (((c2 &&& 0x03) <<< 6) ||| c3)
    i := i + 4
  return result

/-- Decode a Base64 string and interpret the result as UTF-8.
    Returns `none` if the input is invalid Base64 or the decoded bytes
    are not valid UTF-8. -/
def decodeString (encoded : String) : Option String := do
  let bytes ← decode encoded
  String.fromUTF8? bytes

end Base64
