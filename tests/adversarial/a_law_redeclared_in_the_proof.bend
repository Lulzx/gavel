import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

law add_plus:
  for x: Nat
  for y: Nat
  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
