import Base
import ./prelude.bend as P

# TODO(policy): implement. `snoc_each(xss, y)` appends `y` to the end of every
# row: `Nil{}` is `Nil{}`, and a cons cell is its first row with `y` on the end
# (that is what `P.snoc` is for) in front of the same function on the remaining
# rows.
def snoc_each(xss: List<&2, List<&2, Nat>>, +y: Nat) -> List<&2, List<&2, Nat>>:
  ?TODO

# TODO(policy): implement. `front_each(xss, y)` puts `y` at the front of every
# row: `Nil{}` is `Nil{}`, and a cons cell is `y` on the front of its first row
# in front of the same function on the remaining rows.
def front_each(xss: List<&2, List<&2, Nat>>, +y: Nat) -> List<&2, List<&2, Nat>>:
  ?TODO
