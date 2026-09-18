import Base
import ./prelude.bend as P

# The whole list is summed whatever the count is, so the count is only matched on
# and never used. `sq_prefix_zero` rejects it outright -- the law wants `0n` and
# the body answers `P.sq_sum(xs)` -- and `sq_prefix_len` is not dischargeable
# either: the body's answer is `P.sq_sum(xs)` on both sides, but only after a
# reduction the proof's induction step has no hypothesis to rewrite with.
def sq_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      P.sq_sum(xs)
    case 1n+k:
      P.sq_sum(xs)
