import Base
import ./prelude.bend as P

def sum_to(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      +p = p
      sum_to(n) + (1n + p)
