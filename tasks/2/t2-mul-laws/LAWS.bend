import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `add` is Base's addition. Both laws below reach `add` only through
# `mul_succ`'s right-hand side, and only at the pairs `(mul(x, y), x)`, so an
# `add` agreeing with `+` there and nowhere else satisfies them both. Written
# the other way round, `x + y` is Base's addition and `S.add` is the policy's,
# so this law is what makes the stub's first obligation an obligation. Same
# shape as `t1-mul-zero` (Fact 33), `t1-double` and `t1-mul-one`.
law add_plus:
  for x: Nat
  for y: Nat
  {S.add(x, y) == x + y : Nat}

# LAW: one is a left identity for multiplication.
law mul_one_left:
  for x: Nat
  {S.mul(1n, x) == x : Nat}

# LAW: multiplying by a successor adds one more copy of the other factor.
law mul_succ:
  for x: Nat
  for y: Nat
  {S.mul(x, 1n+y) == S.add(S.mul(x, y), x) : Nat}
