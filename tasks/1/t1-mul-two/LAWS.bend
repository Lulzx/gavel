import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: multiplying by two is adding a number to itself. The `+` is Base's
# addition, not `S.add`, so no `mul` that ignores its argument can satisfy it:
# both sides depend on `x`, and a constant `mul` makes them disagree.
law mul_two:
  for x: Nat
  {S.mul(2n, x) == x + x : Nat}
