import Base
import ./prelude.bend as P

# Wrong: the recursion passes the count on instead of decrementing it, so
# `take` answers the whole list for every `n` once it has started. The law
# rules it out -- what it appends to the remainder is not what is left.
def take(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match n:
        case 0n:
          Nil{}
        case 1n+p:
          h <> take(t, 1n+p)
