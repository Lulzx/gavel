import Base
import ./prelude.bend as P

# TODO(policy): implement. `index_of(xs, k)` is the position of the first
# element of `xs` that is `k`, counting from `0n`, or `P.len(xs)` -- one past
# the last position -- when `k` does not occur. Recurse on the list: the empty
# list answers `0n`, which is its length, and a cons cell is compared with the
# target and either answers `0n` or steps the position of the rest on by one.
#
# The comparison is `P.eq(h, k)` and the decision is *taken* by `P.at_if`, which
# matches on the value it is given: a match cannot scrutinise a computed value
# in place, so the comparison is passed on rather than taken here. The target is
# read twice in the step, once into the comparison and once into the recursive
# call, so it is declared reusably (`+k`).
def index_of(xs: List<Nat>, +k: Nat) -> Nat:
  ?TODO
