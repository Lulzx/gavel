import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`; the empty list has no pair and
# answers `0n`, and a cons cell answers the better of the head's best rise into
# the tail -- the prelude's `P.max_sub` -- and the best gain among the tail's
# own pairs. The tail is read twice, once by each, so the cons pattern marks it
# reusable and the list type is `List<&2, Nat>`.
def best_gain(xs: List<&2, Nat>) -> Nat:
  ?TODO
