import Base
import ./prelude.bend as P

def sum_to(n: Nat) -> Nat:
  match n:
    case 1n:
      0n
    case 1n+p:
      +p = p
      sum_to(p) + (1n + p)
