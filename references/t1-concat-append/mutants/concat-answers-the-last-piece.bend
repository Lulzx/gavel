import Base
import ./prelude.bend as P

# Wrong: `concat` throws each piece away and answers the last one. The law's
# right-hand side is `append(concat(xss), ys)`, so a `concat` that drops `a`
# differs from it for a variable `ys` -- the piece has to survive into the
# concatenation.
def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case a <> rest:
      concat(rest)
