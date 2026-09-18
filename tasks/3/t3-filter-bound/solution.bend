import Base
import ./prelude.bend as P

# TODO(policy): implement both. `filter(xs, n)` returns the elements of `xs`
# that are at most `n`; `len(xs)` returns how many elements `xs` has. Both
# recurse on `xs`. `P.le`, `P.below_put`, `P.below_count` and `P.filter_put`
# are the prelude's and are immutable.
def filter(xs: List<Nat>, +n: Nat) -> List<Nat>:
  ?TODO

def len(xs: List<Nat>) -> Nat:
  ?TODO
