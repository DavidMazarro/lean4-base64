# lean4-base64

RFC 4648 Base64 encoding and decoding library for Lean 4.

## Origin

Created for [predictable-code](https://github.com/predictable-machines/predictable-code) to replace scattered Base64 implementations and `openssl` shell-outs (issue predictable-machines/predictable-code#395).

## Build

Uses Lake build system, targeting Lean v4.28.0 (pinned in `lean-toolchain`).

```bash
make              # Build library
make test         # Build and run tests
make rebuild      # Clean and rebuild
```

## Architecture

```
Base64/
├── Encode.lean    # encode, encodeUrl, encodeString
└── Decode.lean    # decode, decodeString
```

## Module Organization

- Each folder has an `Index.lean` that re-exports all modules
- Use hierarchical imports: `import Base64`
- When adding new files: create file, add import to parent Index.lean

## Code Style

- Multi-line function signatures: each parameter on its own line with 4-space indent
- Braces on same lines as content
- No default parameter values
- Use plain `_` for discarded parameters
- Comments explain "why", not "what"

## Pull Request Conventions

Include `Fixes #<issue-number>` on first line of PR body to auto-close issues.
