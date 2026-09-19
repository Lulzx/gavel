import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the list; the empty list counts nothing,
# and a record contributes `P.same` of its two halves in front of whatever the
# tail contributes. The tail is recursed on with the record's halves already
# taken out of it, and the match on the record is what the recursion steps on.
def count_if(ps: List<&2, P.Pair>) -> Nat:
  ?TODO
