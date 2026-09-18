import Base
import ./prelude.bend as P

# Wrong: the base case answers `1n` instead of `0n`, so every count carries a
# constant offset. `count_zeros_snoc` cannot see it -- it is a recurrence in
# both `xs` and `x`, and an offset added on both sides preserves it -- and
# against the *reference* proof this file stops at `Policy.add_zero`, which
# expects `is_zero(x) + 0n` and finds `is_zero(x) + 1n`. That is the proof's
# shape catching it, not the law set: **a restructured proof let this body
# through at tier 4, reward 1.000**, measured 2026-09-19 by matching on `x` in
# the empty branch and discharging the residual `1n + 0n` with `Policy.add_zero`.
# `count_zeros_nil` is the closed anchor that closes it for real; this file now
# measures tier 3, failing at `LAWS.count_zeros_nil`.
def count_zeros(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      P.is_zero(h) + count_zeros(t)
