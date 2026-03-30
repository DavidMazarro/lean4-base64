# lean4-base64

RFC 4648 Base64 encoding and decoding for Lean 4.

## Features

- Standard Base64 encoding/decoding (RFC 4648 Section 4)
- URL-safe Base64 encoding (RFC 4648 Section 5)
- Whitespace-tolerant decoding
- Pure Lean implementation with no external dependencies

## Installation

Add to your `lakefile.lean`:

```lean
require «lean4-base64» from git
  "https://github.com/predictable-machines/lean4-base64" @ "v0.1.0^{}"
```

## Usage

```lean
import Base64

-- Encode bytes to standard Base64
let encoded := Base64.encode "Hello, World!".toUTF8
-- "SGVsbG8sIFdvcmxkIQ=="

-- Encode a string directly
let encoded := Base64.encodeString "Hello, World!"
-- "SGVsbG8sIFdvcmxkIQ=="

-- URL-safe encoding (for JWTs, URLs, etc.)
let urlSafe := Base64.encodeUrl "Hello, World!".toUTF8
-- "SGVsbG8sIFdvcmxkIQ"

-- Decode Base64 to bytes
let decoded := Base64.decode "SGVsbG8sIFdvcmxkIQ=="
-- some #[72, 101, 108, 108, 111, ...]

-- Decode Base64 to string
let decoded := Base64.decodeString "SGVsbG8sIFdvcmxkIQ=="
-- some "Hello, World!"
```

## Build

```bash
make build    # Build the library
make test     # Build and run tests
make clean    # Clean build artifacts
```

## License

MIT
