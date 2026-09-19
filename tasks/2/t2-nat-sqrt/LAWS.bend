import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing below `1n` has a square under it, so the answer at `0n` is `0n`.
# Both sides compute and the right-hand side calls no target: this is the absolute
# anchor, and it is the only law that reaches the empty input through `nat_sqrt`
# itself. A body that started its walk at one, or that answered the number of
# steps taken rather than the count of them, is caught here and nowhere else.
law nat_sqrt_zero:
  {S.nat_sqrt(0n) == 0n : Nat}

# LAW: the hand-off from the answer to the next one. Raising `n` by one raises the
# square root by at most one, so the answer for `1n + n` is the answer for `n`
# plus the decision `P.le_ind` makes: one when the square of the next number still
# fits under `1n + n`, none when it does not. Both sides compute, so this is
# definitional, and it is the law that pins *which* square is tested -- a body
# that tested the square of the answer instead of the next one, or that tested it
# against a different bound, leaves the two sides unconvertible here.
law nat_sqrt_succ:
  for +n: Nat
  {S.nat_sqrt(1n + n) == Nat.add(S.nat_sqrt(n), P.le_ind(Nat.mul(1n + S.nat_sqrt(n), 1n + S.nat_sqrt(n)), 1n + n)) : Nat}

# LAW: the answer never falls as `n` grows. This is the law with content, and it
# is the only one whose two sides do not both compute: `n` is a variable, so the
# match in the body does not reduce and the law cannot be closed by computation --
# it is proved from the answer's own step. It is also the law that reads the
# answer as an order rather than as a number: a body whose answer ever moved down
# from one `n` to the next is separated here even where an exact square or two
# still line up.
law nat_sqrt_mono:
  for +n: Nat
  {P.le_ind(S.nat_sqrt(n), S.nat_sqrt(1n + n)) == 1n : Nat}

# LAW: the exact square `4n`, read on its own. `2n * 2n` is `4n`, so the answer is
# `2n` and not `1n`. Both sides are closed, so every match reduces. A body that
# stopped one short on the exact square -- where the next square fits with nothing
# to spare -- satisfies the monotonicity law above and the step law's shape, and is
# separated here.
law nat_sqrt_four:
  {S.nat_sqrt(4n) == 2n : Nat}

# LAW: one closed number just below a square, read on its own. `2n * 2n` is `4n`
# and `3n * 3n` is `9n`, so `8n` is not below `3n * 3n`: the answer is `2n`. Both
# sides are closed. This is the law that reads the *gap* between two squares: a
# body that raised the answer one step early -- testing whether the answer's own
# square, or the next square plus something, still fits -- answers `3n` here while
# still answering `2n` at `4n` and `3n` at `9n`, and is separated only here.
law nat_sqrt_eight:
  {S.nat_sqrt(8n) == 2n : Nat}

# LAW: one closed number that is not a square, read on its own. `3n * 3n` is `9n`
# and `2n * 2n` is `4n`, so the answer at `9n` is `3n`. Both sides are closed. A
# body that overshot at an exact square is separated by the law above; this one
# separates a body whose answer drifted over a run of numbers between two squares
# -- the readings that take the answer from the count of something other than
# fitting squares line up at `0n` and `4n` and part here.
law nat_sqrt_nine:
  {S.nat_sqrt(9n) == 3n : Nat}
