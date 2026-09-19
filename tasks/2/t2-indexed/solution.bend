import Base
import ./prelude.bend as P

# TODO(policy): implement. `indexed(xs)` packs every element with the position
# it is at, counting from `0n`: the head is paired with the current position and
# the tail is numbered from the next one, so the count is carried down the list
# as a second argument. The list is the argument that shrinks, and in Bend the
# shrinking argument has to come before any argument that is passed changed, so
# the list comes first and the position second. The position is read twice in
# the step -- once into the pair and once into the recursive call -- so it is
# declared reusably (`+i`).
def indexed_go(xs: List<&2, Nat>, +i: Nat) -> List<&2, P.Indexed>:
  ?TODO

# TODO(policy): implement. `indexed` is the helper above, started at `0n`.
def indexed(xs: List<&2, Nat>) -> List<&2, P.Indexed>:
  ?TODO
