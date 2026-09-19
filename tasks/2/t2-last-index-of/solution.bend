import Base
import ./prelude.bend as P

# TODO(policy): implement. `last_index_of(xs, k)` is the position of the *last*
# element of `xs` that is `k`, counting from `0n`, or `P.len(xs)` -- one past
# the last position -- when `k` does not occur.
#
# Recurse on the list, but answer from the tail's side, because it is the last
# occurrence that is wanted: the tail decides whether the head's own occurrence
# is the one being asked for. `P.has_k(t, k)` says whether the target still
# occurs in the tail. When it does, the head does not matter and the answer is
# the tail's answer stepped on by one; when it does not, the head is the last
# chance -- `0n` when the head is the target, and otherwise the tail's answer
# stepped on by one, which is the sentinel.
#
# The comparisons are `P.eq` and the decisions are *taken* by `P.at_if`, which
# matches on the value it is given: a match cannot scrutinise a computed value
# in place, so the comparison is passed on rather than taken here. The tail is
# read twice in the step, once into `P.has_k` and once into the recursive call,
# so it is declared reusably (`+t`); the target is read three times, so it is
# declared reusably as well (`+k`).
def last_index_of(xs: List<&2, Nat>, +k: Nat) -> Nat:
  ?TODO
