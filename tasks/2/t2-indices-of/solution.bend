import Base
import ./prelude.bend as P

# TODO(policy): implement. `indices_of(xs, k)` is the list of every position at
# which `xs` holds `k`, ascending from `0n`:
#
#   indices_of([5n, 7n, 5n], 5n)  ==  [0n, 2n]
#   indices_of([5n, 7n, 5n], 9n)  ==  []
#
# Recurse on the list: the empty list answers `Nil{}`, and a cons cell compares
# its head with the target and answers the position `0n` consed onto the shifted
# positions of the tail when they are equal, and just the shifted positions of
# the tail when they are not. "Shifted" means one step per position the head
# stands in front of, so a hit behind this cell is one further along.
#
# The comparison is `P.eq(h, k)` and the decision is *taken* by `P.cons_if`,
# which matches on the value it is given: a match cannot scrutinise a computed
# value in place, so the comparison is passed on rather than taken here. The
# target is read twice in the step, once into the comparison and once into the
# recursive call, so it is declared reusably (`+k`).
def indices_of(xs: List<Nat>, +k: Nat) -> List<Nat>:
  ?TODO
