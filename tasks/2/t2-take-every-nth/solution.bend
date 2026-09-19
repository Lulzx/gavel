import Base
import ./prelude.bend as P

# TODO(policy): implement. `take_every_nth(n, xs)` answers every `n`th element
# of `xs`, counting from the first, so the elements at positions `0n`, `n`,
# `2n`, ... and nothing else. `n = 0n` names no position, so the answer there is
# the empty list.
def take_every_nth(n: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO

# TODO(policy): implement. The walk behind the answer. `m` is the number of
# elements to skip between two kept ones -- one less than the stride -- and `i`
# counts the skips still owed, so the head is kept when `i` reaches `0n` and
# passed over otherwise. The list comes first because it is the argument that
# shrinks. `m` is read twice on the keeping step -- once as the count that was
# exhausted and once as the count the next gap starts from -- so it is declared
# reusable.
def every_nth_go(xs: List<&2, Nat>, +m: Nat, i: Nat) -> List<&2, Nat>:
  ?TODO
