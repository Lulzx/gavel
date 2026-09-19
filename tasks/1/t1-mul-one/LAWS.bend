import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `add` is Base's addition. The three laws below reach `add` only through
# `mul_succ`'s right-hand side, and only at the pairs `(y, mul(x, y))`, so an
# `add` agreeing with `+` there and nowhere else is untouched by them. Written
# the other way round, `x + y` is Base's addition and `S.add` is the policy's,
# so this law is what makes the stub's first obligation an obligation. Same
# shape as `t1-mul-zero` (Fact 33) and `t1-double`.
law add_plus:
  for x: Nat
  for y: Nat
  {S.add(x, y) == x + y : Nat}

# LAW: multiplying by one on the right changes nothing.
law mul_one:
  for x: Nat
  {S.mul(x, 1n) == x : Nat}

# LAW: the step `mul` recurses with, for a successor on the left. It closes by
# reduction; it is what keeps the pair from being satisfied by a `mul` that
# ignores its second argument.
law mul_succ:
  for x: Nat
  for y: Nat
  {S.mul(1n+x, y) == S.add(y, S.mul(x, y)) : Nat}

# LAW: zero times anything is zero. The two laws above pin `mul` on the line
# `y == 1n` and along the recursion, and between them they fix the base case at
# exactly one point: `mul_succ` at `x == 0n` and `mul_one` at `x == 1n` together
# give `P.add(1n, S.mul(0n, 1n)) == 1n`, so `mul(0n, 1n)` is `0n` and nothing
# says what `mul(0n, y)` is for any other `y`. **Measured 2026-09-19:** a body
# -- `mul`'s own `0n` case replaced by a nested match answering `0n` for
# `y <= 1n` and `1n` for `y >= 2n` -- reads **tier 4, complete, reward 1.000
# against the reference proof**, and it is not multiplication. This law is the
# missing anchor: `mul(0n, y)` is `0n` at every `y`, and with the step above it
# determines `mul` by induction on the first argument.
law mul_zero:
  for y: Nat
  {S.mul(0n, y) == 0n : Nat}
