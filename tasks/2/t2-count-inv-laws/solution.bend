import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`; the empty list has no pairs and
# answers `0n`, and a cons cell answers the tail's own count plus the number of
# elements of the tail that are below the head, which is the prelude's
# `P.count_gt`. The tail is read twice -- once by that count and once by the
# recursion -- so the cons pattern marks it reusable.
def count_inv(xs: List<&2, Nat>) -> Nat:
  ?TODO
