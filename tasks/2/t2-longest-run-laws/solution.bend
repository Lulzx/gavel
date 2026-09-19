import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`; the empty list has no element and
# answers `0n`, and a cons cell answers the better of the block that starts at
# its first element -- the prelude's `P.run_len` -- and the longest run inside
# its tail. The tail is read twice, so the cons pattern marks it reusable and
# the list type is `List<&2, Nat>`.
def longest_run_len(xs: List<&2, Nat>) -> Nat:
  ?TODO
