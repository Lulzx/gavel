import Base
import ./prelude.bend as P
import ./solution.bend as S

law sneaky:
  for x: Nat
  {x == x : Nat}
