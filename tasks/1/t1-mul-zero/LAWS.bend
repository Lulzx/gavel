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

# LAW: multiplying zero on the left gives zero. Neither law above mentions
# `mul(0n, y)` with a variable `y`: `mul_zero` reaches the `0n` case of `a` only
# with the other factor also `0n`, and `mul_succ_left` never reaches it. A `mul`
# answering its second argument there -- `case 0n: b`, the projection this
# task's own `add` would give -- proves both at tier 4, reward 1.000.
law mul_zero_left:
  for y: Nat
  {S.mul(0n, y) == 0n : Nat}
