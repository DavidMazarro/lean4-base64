import Base64Test.TestRunner
import Base64Test.Core.Index

def main : IO Unit := do
  IO.println "Running Base64 tests..."
  TestRunner.run CoreTests.allTests
