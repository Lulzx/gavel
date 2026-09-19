import Base
import ./prelude.bend as P

# TODO(policy): implement. `max_prefix_sum(xs)` is the largest sum over any
# prefix of `xs`. The empty prefix is one of the prefixes and sums to `0n`, so
# an empty list answers `0n` and a non-empty list can never answer less. The
# answer is the walk started with nothing accumulated and nothing seen.
def max_prefix_sum(xs: List<&2, Nat>) -> Nat:
  ?TODO

# TODO(policy): implement. `max_prefix_sum_go(xs, acc, best)` walks `xs`
# carrying the sum of the elements consumed so far and the largest prefix sum
# seen so far. The empty list answers the best running value -- there is no
# prefix left to consider. A cons cell adds its head to the running sum and
# keeps whichever of that new sum and the best so far is larger, then recurses
# on the tail. The new sum is read twice in that step, once as the accumulator
# and once inside the comparison, so both the head and the running sum are
# declared reusable: `+h` and `+acc`.
def max_prefix_sum_go(xs: List<&2, Nat>, +acc: Nat, best: Nat) -> Nat:
  ?TODO
