import Base
import ./prelude.bend as P

# Wrong: `reverse` drops the head of every cons instead of moving it to the
# end. The law's right-hand side is `x <> reverse(xs)`, so the head is still
# visible after the recursion -- the length law would not see this.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      reverse(t)
