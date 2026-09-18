import Base
import ./prelude.bend as P

# TODO(policy): the last element of `xs`, or `d` when `xs` is empty. `d` is
# answered on the empty list and is replaced by the head on every cons, so the
# recursion carries the element it has seen so far down the list.
def last(xs: List<&2, Nat>, d: Nat) -> Nat:
  ?TODO
