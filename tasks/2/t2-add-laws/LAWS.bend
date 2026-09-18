import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: for every x, x + 0 is x.
law add_zero:
  for x: Nat
  {S.add(x, 0n) == x : Nat}

# LAW: adding a successor on the right is the successor of adding.
law add_succ:
  for x: Nat
  for y: Nat
  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
