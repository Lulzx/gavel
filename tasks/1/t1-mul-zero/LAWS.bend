import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `add` is Base's addition. The stub declares `add` and `mul` and the
# prompt asks for both, but the three laws above are written against Base's `+`,
# so they constrain `add` only where `mul` happens to call it -- and a `mul`
# that writes its own step as `b + mul(p, b)` never calls it. Measured at tier
# 4, reward 1.000, with `add(a, b) = 0n` and the rest of the reference `mul`.
# Written the other way round, `x + y` is Base's addition and `S.add` is the
# policy's, so this law is what makes the stub's first obligation an obligation.
law add_plus:
  for x: Nat
  for y: Nat
  {S.add(x, y) == x + y : Nat}

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
