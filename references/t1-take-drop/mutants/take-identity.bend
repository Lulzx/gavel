import Base
import ./prelude.bend as P

# Wrong: returns the whole list, so nothing is ever held back for `drop`.
def take(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> t
