import Base
import ./prelude.bend as P

# TODO(policy): implement. `second_max(xs)` is the second largest element of
# `xs`, or `0n` when there is none. The empty list has none. A cons cell hands
# its tail to the walk with the head as the largest seen so far and `0n` as the
# second, which is the only place the walk is started.
def second_max(xs: List<&2, Nat>) -> Nat:
  ?TODO

# TODO(policy): implement. `sec_go(xs, top, second)` walks `xs` carrying the
# largest and second largest elements seen so far. The empty list answers the
# second running value -- the walk has already folded everything in. A cons cell
# folds its head into both running values and recurses on the tail: the new
# largest is `P.max2(h, top)`, and the new second is `P.max2(P.min2(h, top),
# second)`, since a head below the largest replaces the second only if it is
# above it. `top` is read twice in that step, so it is declared reusable.
def sec_go(xs: List<&2, Nat>, +top: Nat, second: Nat) -> Nat:
  ?TODO
