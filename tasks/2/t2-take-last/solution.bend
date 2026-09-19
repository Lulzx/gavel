import Base
import ./prelude.bend as P

# TODO(policy): implement. `take_last(xs, k)` is the last `k` elements of `xs`,
# and all of `xs` when it has fewer than `k` of them:
#
#   take_last([1n, 2n, 3n, 4n], 2n)  ==  3n <> (4n <> Nil{})
#   take_last([1n, 2n, 3n, 4n], 4n)  ==  1n <> (2n <> (3n <> (4n <> Nil{})))
#   take_last([1n, 2n], 5n)          ==  1n <> (2n <> Nil{})
#   take_last([1n, 2n], 0n)          ==  Nil{}
#   take_last(Nil{}, 3n)             ==  Nil{}
#
# The list is the argument that shrinks, so it comes first. Each step asks how
# long the list it is holding is (`P.len`) and whether `k` is at least that long
# (`P.le`): while it is not, the head cannot be part of the last `k` and is
# dropped, and the same count is asked of the tail; the moment it is, the list
# it is holding is the answer. The step hands its decision to `P.keep_if`,
# because a `match` cannot scrutinise a call.
#
# `k` is read twice -- once for the comparison and once by the recursive call --
# so it is declared reusable: `+k`. In the cons pattern the head is read twice
# (on its own, and inside `P.len`) and the tail three times (inside `P.len`, in
# the list the answer may be, and by the recursive call), so both binders are
# reusable: `case +h <> +t:`.
def take_last(xs: List<&2, Nat>, k: Nat) -> List<&2, Nat>:
  ?TODO
