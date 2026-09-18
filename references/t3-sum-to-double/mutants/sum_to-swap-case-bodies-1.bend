import Base
import ./prelude.bend as P

def sum_to(n: Nat) -> Nat:
  match n:
    case 0n:
      +p = p
      sum_to(p) + (1n + p)

    case 1n+p:
      0n
