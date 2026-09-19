import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an exhausted width answers `False{}`, whatever the number is. The
# left-hand side is ground in the width and both sides compute, so this is
# definitional. It is the law that pins the *stopped* answer: `1n` is a power of
# two, and a body that answered `True{}` on an exhausted width would satisfy
# every law below at every width above zero, because none of them reaches width
# zero. The width only bounds the walk; it is not part of the answer.
law is_pow2_no_fuel:
  for n: Nat
  {S.is_pow2(0n, n) == False{} : Bool}

# LAW: zero is not a power of two, at any width. This is an absolute anchor --
# it is one of the two answers the function has to give, and nothing above
# relates it to anything else. With a variable width the left-hand side does not
# reduce on its own, so this one is inductive in the width: the inner match
# takes its zero case at every width above zero, and only the width-zero case
# falls to the law above.
law is_pow2_zero:
  for w: Nat
  {S.is_pow2(w, 0n) == False{} : Bool}

# LAW: one is a power of two, at any width above zero. The other absolute
# anchor, and the one that rules out a body that answers `False{}` everywhere.
# The width is written `1n + w` on the left so that the reference body's outer
# match steps into its successor case with `p` bound to `w`, and the inner match
# then reads the literal `1n`; that makes this law definitional, unlike the one
# above. Zero width is deliberately excluded: at zero width the answer is
# `False{}`, and the law above says so.
law is_pow2_one:
  for w: Nat
  {S.is_pow2(1n + w, 1n) == True{} : Bool}

# LAW: the step. A number above one is a power of two exactly when it is even
# and half of it is one, with one unit of width spent. This is the law with the
# content, and it is definitional: the outer match steps on `1n + w` and the
# inner match steps on `1n + 1n + q`, so both sides carry the same stuck parity
# term and the same halved argument. A body that dropped the parity test, or
# halved without testing, or recursed on `n` instead of on `P.half(n)`, leaves
# the two sides unconvertible.
law is_pow2_step:
  for +w: Nat
  for +q: Nat
  {S.is_pow2(1n + w, 1n + 1n + q) == Bool.and(P.is_even_b(1n + 1n + q), S.is_pow2(w, P.half(1n + 1n + q))) : Bool}

# LAW: one closed value that is a power of two. `4n` is above one, so the step
# law is what this one unfolds; three units of width are exactly enough to reach
# `1n` (the walk is `4n`, `2n`, `1n`), and the answer is `True{}`. A body that
# answered `False{}` on the `1n` case would still satisfy every law above at the
# widths they name, so this is the law that pins the `True{}` arm.
law is_pow2_four:
  {S.is_pow2(3n, 4n) == True{} : Bool}

# LAW: one closed value that is not a power of two, though it is even. `6n`
# passes the parity test and halves to `3n`, which fails it, so the answer is
# `False{}`. This is the law that separates a power-of-two test from a parity
# test: a body that answered `P.is_even_b(n)` would get every power of two right
# and still answer `True{}` here.
law is_pow2_six:
  {S.is_pow2(3n, 6n) == False{} : Bool}
