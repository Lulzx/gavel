import Base
import ./prelude.bend as P

def fact(+n: Nat) -> Nat:
  match n:
    case 1n:
      1n
    case 1n++k:
      Nat.mul(n, fact(k))
