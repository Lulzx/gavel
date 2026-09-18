import Base
import ./prelude.bend as P

# Wrong: counts the elements but throws each head away, so the pieces of the
# decomposition do not add up to the original list.
def take(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match n:
        case 0n:
          Nil{}
        case 1n+p:
          take(t, p)
