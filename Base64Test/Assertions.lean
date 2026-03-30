def Assert : Bool → String → IO Unit
  | true, _ => pure ()
  | false, msg => throw <| IO.userError msg

def AssertEqual [Repr α] [BEq α] : α → α → IO Unit
  | a, b => Assert (a == b) s!"{reprStr a} should be equal to {reprStr b}"

def shouldEqual
    [Repr α]
    [BEq α]
    (expected : α)
    (actual : α)
    : IO Unit :=
  AssertEqual actual expected

def shouldBeEmpty [Repr α] (list : List α) : IO Unit :=
  Assert list.isEmpty s!"Expected empty list, got {reprStr list}"

def shouldBeSome
    [Repr α]
    [BEq α]
    (expected : α)
    (actual : Option α)
    : IO Unit :=
  match actual with
  | some value => value |> shouldEqual expected
  | none => throw <| IO.userError s!"Expected some {reprStr expected}, got none"

def shouldBeNone
    [Repr α]
    (actual : Option α)
    : IO Unit :=
  match actual with
  | none => pure ()
  | some value => throw <| IO.userError s!"Expected none, got some {reprStr value}"
