import Base
import ./prelude.bend as P

# TODO(policy): implement. `dec2_all(xs)` replaces every element with the element minus two, saturating at zero.
# Match on the list: `Nil{}` is `Nil{}`, and a cons cell conses the element minus two, saturating at zero of
# the head onto the mapped tail.
def dec2_all(xs: List<Nat>) -> List<Nat>:
  ?TODO
