import Base
import ./prelude.bend as P

# TODO(policy): implement. `distinct(xs)` is `xs` with every duplicate removed,
# keeping the *first* occurrence of each element and the order of the rest:
#
#   distinct([1n, 2n, 1n])          ==  1n <> 2n <> Nil{}
#   distinct([3n, 3n, 3n])          ==  3n <> Nil{}
#   distinct([1n, 2n, 3n])          ==  1n <> 2n <> 3n <> Nil{}
#
# It is not `dedup`: an element is dropped when it occurred anywhere *earlier*,
# not only when it sits next to its twin.
def distinct(xs: List<&2, Nat>) -> List<Nat>:
  ?TODO

# TODO(policy): implement. `distinct_go(xs, seen)` walks the tail of a list whose
# earlier elements are already in `seen`, carrying that set along. The empty list
# answers the empty list -- there is nothing left to keep. A cons cell tests its
# head with `P.mem(seen, h)` and either leaves it out or keeps it in front of the
# rest of the walk, and it recurses with the head *added* to the set, which is
# what lets a later duplicate of it be recognised. The decision is taken by
# `P.skip_if`, which matches on the value it is handed: a match cannot scrutinise
# a computed value in place, so the test is passed on rather than taken here.
# The head is read three times in the step and `seen` twice, so both are declared
# reusable.
def distinct_go(xs: List<&2, Nat>, +seen: List<&2, Nat>) -> List<Nat>:
  ?TODO
