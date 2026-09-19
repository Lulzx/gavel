import Base
import ./prelude.bend as P

def fact(+n: Nat) -> Nat:
  match n:
    case 0n:
      Nat.mul(n, fact(k))

    case 1n++k:
      1n
