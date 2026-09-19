import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an exhausted width answers `0n`, whatever the number is. The left-hand
# side is ground in the width and both sides compute, so this is definitional.
# It is the law that pins the *stopped* answer: the width only bounds the walk
# and is not part of the answer, so a body that answered something else on an
# exhausted width -- a sentinel, or the number itself -- satisfies every law
# below at every width above zero, because none of them reaches width zero.
law log2_go_no_fuel:
  for n: Nat
  {S.log2_go(0n, n) == 0n : Nat}

# LAW: zero has no logarithm, and this task answers `0n` for it -- every power
# of two is at least `1n`, so there is no exponent to report and the walk stops
# rather than guessing one. With a variable width the left side does not reduce
# on its own, so this one is inductive in the width: the inner match takes its
# zero case at every width above zero, and only the width-zero case falls to the
# law above. It is an absolute anchor -- the right side calls no target.
law log2_go_zero:
  for w: Nat
  {S.log2_go(w, 0n) == 0n : Nat}

# LAW: one is the same answer by a different arm. `1n` is the base of the
# logarithm, so the exponent is `0n`, not `1n`, and this is the law that
# separates the two: a body that counted a halving for `1n` -- the natural
# mistake, since every other number above `1n` spends one -- answers `1n` here.
# The width is written `1n + w` so that the outer match steps into its successor
# case and the inner match reads the literal `1n`; that makes it definitional,
# unlike the law above. Zero width is deliberately excluded.
law log2_go_one:
  for w: Nat
  {S.log2_go(1n + w, 1n) == 0n : Nat}

# LAW: the step. A number above one spends one halving and adds it to the walk
# below it, on the number half as large. This is the law with the content, and
# it is definitional: the outer match steps on `1n + w` and the inner match
# steps on `1n + 1n + q`, so both sides carry the same halved argument and the
# same one added to it. A body that recursed on `n` instead of on `P.half(n)`,
# or that added nothing, or that added the number rather than one, leaves the
# two sides unconvertible.
law log2_go_step:
  for +w: Nat
  for +q: Nat
  {S.log2_go(1n + w, 1n + 1n + q) == 1n + S.log2_go(w, P.half(1n + 1n + q)) : Nat}

# LAW: the hand-off from the answer to the walk. The width the answer starts
# with is `n` itself -- always enough, since halving reaches `1n` within `n`
# steps -- so `nat_log2` is a function of `n` alone and not of the width. Both
# sides compute, so this is definitional; a body that started the walk at a
# fixed width, or that returned the width, is separated here.
law nat_log2_handoff:
  for +n: Nat
  {S.nat_log2(n) == S.log2_go(n, n) : Nat}

# LAW: the smallest value, and the one that fixes the decision at `0n`. The
# right side calls no target, so this is an absolute anchor.
law nat_log2_zero:
  {S.nat_log2(0n) == 0n : Nat}

# LAW: the base of the logarithm. `2n` is `1n` halving away from `1n`, so the
# answer is `1n`; a body counting halvings without the `1n` case, or answering
# the number of bits, is separated at `1n` and here. The right side calls no
# target, so this is an absolute anchor.
law nat_log2_one:
  {S.nat_log2(1n) == 0n : Nat}

# LAW: the first step, in closed form. It is the smallest `n` the step law
# applies to, and it is what separates a body that reports the walk's own
# starting width from one that reports the exponent. The right side calls no
# target, so this is an absolute anchor.
law nat_log2_two:
  {S.nat_log2(2n) == 1n : Nat}

# LAW: a closed value that is not a power of two. `7n` sits between `4n` and
# `8n`, so its logarithm is `2n` and not `3n`: the floor is what the answer is,
# and a body rounding up -- or counting the number of times the halved value is
# even rather than the number of halvings -- answers `3n` here. The right side
# calls no target, so this is an absolute anchor.
law nat_log2_seven:
  {S.nat_log2(7n) == 2n : Nat}

# LAW: the power of two just above it. `8n` is three halvings from `1n`, so the
# answer is `3n`; read with `nat_log2_seven` it pins the boundary -- the two
# values either side of it differ by one, which is what a floor does and what no
# law stated only at powers of two could see. The right side calls no target, so
# this is an absolute anchor.
law nat_log2_eight:
  {S.nat_log2(8n) == 3n : Nat}
