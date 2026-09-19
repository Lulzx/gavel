import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_matches(xs, ys)` counts the positions where
# the two lists agree, stopping at whichever runs out first. Recurse on both
# lists: either list running out gives `0n`, and two cons cells add `1n` to the
# tail's count when the heads are equal and `0n` otherwise. `P.eq`, `P.pick`
# and `+` come from the prelude and `Base`.
def count_matches(xs: List<Nat>, ys: List<Nat>) -> Nat:
  ?TODO
