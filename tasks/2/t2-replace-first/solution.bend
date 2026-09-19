import Base
import ./prelude.bend as P

# TODO(policy): implement. `replace_first(xs, k, y)` is `xs` with the *first*
# occurrence of `k` replaced by `y`. Later occurrences are left alone, and a `k`
# that does not occur leaves `xs` unchanged:
#
#   replace_first([1n, 2n, 1n], 1n, 9n)  ==  9n <> 2n <> 1n <> Nil{}
#   replace_first([1n, 2n, 3n], 5n, 9n)  ==  1n <> 2n <> 3n <> Nil{}
#
# The list is the argument that shrinks, so it comes first. A cons cell compares
# its head with `k` -- the prelude's `P.eq` -- and hands that answer, the head,
# the replacement and the tail to `P.rp_branch`, which either drops the head for
# `y` in front of the untouched tail or keeps the head in front of the walk on
# the tail. The comparison is passed on rather than taken here, because a
# `match` cannot scrutinise the result of a call. The head is read twice in the
# step, and `k` and `y` are each read twice, so all three are declared reusable:
# `+h`, `+k`, `+y`.
def replace_first(xs: List<&2, Nat>, +k: Nat, +y: Nat) -> List<&2, Nat>:
  ?TODO
