import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: multiplying by zero on the right gives zero.
law mul_zero:
  for x: Nat
  {S.mul(x, 0n) == 0n : Nat}

# LAW: multiplying a successor on the left is adding the other factor. The `+`
# is Base's addition, not `S.add`, so a degenerate `add` cannot rescue it: no
# `mul` that ignores its argument -- and no pair of argument-ignoring `mul` and
# `add` -- satisfies it. Together with `mul_zero` it pins `mul`.
law mul_succ_left:
  for x: Nat
  for y: Nat
  {S.mul(1n+x, y) == y + S.mul(x, y) : Nat}
