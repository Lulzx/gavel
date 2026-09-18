import Base
import ./prelude.bend as P

# The whole list is counted whatever the count is, so the count is only matched
# on and never used. `zeros_prefix_zero` rejects it outright -- at
# `xs = 0n <> Nil{}` the law wants `0n` and the body answers `1n` -- and
# `zeros_prefix_len` is not dischargeable either: the body's answer is
# `P.count_zeros(xs)` on both sides, but only after a reduction the proof's
# induction step has no hypothesis to rewrite with.
def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      P.count_zeros(xs)
    case 1n+k:
      P.count_zeros(xs)
