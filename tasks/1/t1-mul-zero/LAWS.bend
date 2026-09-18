import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: multiplying by zero on the right gives zero.
law mul_zero:
  for x: Nat
  {S.mul(x, 0n) == 0n : Nat}

# LAW: multiplying by one on the left changes nothing. Inductive in `x`, and it
# is what keeps the pair from being satisfied by a `mul` that ignores its
# argument.
law mul_one_left:
  for x: Nat
  {S.mul(1n, x) == x : Nat}
