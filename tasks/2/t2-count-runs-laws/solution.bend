import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `xs`; the empty list has no runs, a
# one-element list is one run, and from two elements on the answer is the count
# of the list from the second element on, plus one when the first two differ.
# The decision comes from `P.is_eq`, which returns a `Nat`: a `match` may not
# scrutinise a call, so the step adds `P.nsub(1n, P.is_eq(h, h2))` rather than
# branching on a comparison.
def count_runs(xs: List<&2, Nat>) -> Nat:
  ?TODO
