namespace Base64

private def stdAlphabet : String :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

private def lookupChar (idx : Nat) : Char :=
  String.Pos.Raw.get! stdAlphabet ⟨idx⟩

/-- Standard Base64 encoding (RFC 4648 Section 4).
    Uses `+/` alphabet and `=` padding. -/
def encode (data : ByteArray) : String := Id.run do
  if data.isEmpty then return ""
  let mut result := ""
  let mut i := 0
  while i < data.size do
    let b0 := data.get! i
    let b1 := if i + 1 < data.size then data.get! (i + 1) else 0
    let b2 := if i + 2 < data.size then data.get! (i + 2) else 0
    let c0 := (b0 >>> 2).toNat
    let c1 := (((b0 &&& 0x03) <<< 4) ||| (b1 >>> 4)).toNat
    let c2 := (((b1 &&& 0x0F) <<< 2) ||| (b2 >>> 6)).toNat
    let c3 := (b2 &&& 0x3F).toNat
    result := result.push <| lookupChar c0
    result := result.push <| lookupChar c1
    if i + 1 < data.size then
      result := result.push <| lookupChar c2
    else
      result := result.push '='
    if i + 2 < data.size then
      result := result.push <| lookupChar c3
    else
      result := result.push '='
    i := i + 3
  return result

/-- URL-safe Base64 encoding (RFC 4648 Section 5).
    Uses `-_` alphabet with no padding. -/
def encodeUrl (data : ByteArray) : String :=
  encode data
    |>.replace "+" "-"
    |>.replace "/" "_"
    |>.replace "=" ""

/-- Encode a UTF-8 string using standard Base64. -/
def encodeString (s : String) : String :=
  encode s.toUTF8

end Base64
