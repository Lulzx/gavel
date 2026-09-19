import Base
import ./prelude.bend as P

def max_all(ys: List<&2, Nat>, +m: Nat) -> List<&2, Nat>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.max(h, m) <> max_all(t, m)

def cum_max(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> max_all(cum_max(xs), h)
