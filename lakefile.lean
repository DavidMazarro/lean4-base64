import Lake
open Lake DSL

package «lean4-base64» where
  version := v!"0.1.0"

@[default_target]
lean_lib Base64 where
  roots := #[`Base64]

lean_lib Base64Test where
  roots := #[`Base64Test]

lean_exe tests where
  root := `Base64Test.RunBase64Tests
