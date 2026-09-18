import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: adding a successor on the right is the successor of adding.
law add_succ:
  for x: Nat
  for y: Nat
  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
