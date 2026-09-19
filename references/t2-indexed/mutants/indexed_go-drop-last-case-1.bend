import Base
import ./prelude.bend as P

# The reference solution: step on the list and carry the position along. The
# head is paired with the position it is at and the tail is numbered from the
# next one, so the count runs out exactly when the list does. The list comes
# before the position because it is the argument that shrinks, and the position
# is read twice in the step, so it is declared reusably (`+i`).
def indexed_go(xs: List<&2, Nat>, +i: Nat) -> List<&2, P.Indexed>:
  match xs:
    case Nil{}:
      Nil{}

# Counting starts at `0n`, so `indexed` is the helper above applied to the whole
# list at that position.
def indexed(xs: List<&2, Nat>) -> List<&2, P.Indexed>:
  indexed_go(xs, 0n)
