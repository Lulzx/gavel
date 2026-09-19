import Base
import ./prelude.bend as P

# TODO(policy): implement. `chunk_two(xs)` groups the elements of `xs` in twos.
# Match on the list and then on its tail: `Nil{}` is `Nil{}`, a lone element is
# `Nil{}` as well, and two elements or more are `P.MkPair{x, y}` in front of the
# groups of the tail *after* `y`. The recursion is on that shorter tail, which
# is what drops an unpaired last element and what stops the groups overlapping.
def chunk_two(xs: List<Nat>) -> List<&2, P.Pair>:
  ?TODO

# TODO(policy): implement. `join_two(ps)` writes the records out flat, each one
# as its two halves in order: `Nil{}` is `Nil{}`, and a cons cell is its two
# halves in front of the writing out of its tail.
def join_two(ps: List<&2, P.Pair>) -> List<Nat>:
  ?TODO
