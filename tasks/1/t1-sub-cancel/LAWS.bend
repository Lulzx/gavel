import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: subtracting a number from a sum it appears in on the right cancels it.
law sub_cancel:
  for x: Nat
  for y: Nat
  {S.sub(x + y, x) == y : Nat}
