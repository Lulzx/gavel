import Base
import ./prelude.bend as P

# TODO(policy): alternate the elements of `xs` and `ys`, `xs` first, with
# whatever is left of the longer list on the end. Both lists are consumed two at
# a time, so a cons on one side pairs with a cons on the other; `xs` used up
# leaves `ys`, and `ys` used up leaves what is left of `xs`.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
