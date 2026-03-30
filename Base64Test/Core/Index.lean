import Base64Test.Core.EncodeTests
import Base64Test.Core.DecodeTests

namespace CoreTests

def allTests : List (String × IO Unit) :=
  EncodeTests.allTests
  ++ DecodeTests.allTests

end CoreTests
