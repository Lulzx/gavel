import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: for every x, x + 0 is x.
law add_zero:
  for x: Nat
  {S.add(x, 0n) == x : Nat}
