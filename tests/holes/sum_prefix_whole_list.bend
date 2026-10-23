import Base
import ./prelude.bend as P

def sum_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 1n+k:
      P.sum(xs)
    case 0n:
      0n
