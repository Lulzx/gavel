import Base
import ./prelude.bend as P

def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
