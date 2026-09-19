import Base
import ./prelude.bend as P

# TODO(policy): implement. `zip_with(xs, ys)` combines the two lists element by
# element with `P.max` and stops when the shorter of them runs out: the empty
# list on either side gives `Nil{}`, and otherwise the two heads are combined
# and the two tails are combined in the same way. Recurse on the first list and
# then on the second, the way `P.min` steps through its two arguments.
def zip_with(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  ?TODO
