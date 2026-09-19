import Base
import ./prelude.bend as P

# TODO(policy): implement. `swap_each(ps)` swaps the two halves of every record:
# `Nil{}` is `Nil{}`, and a cons cell is its record the other way round in front
# of the same function on the rest.
def swap_each(ps: List<&2, P.Pair>) -> List<&2, P.Pair>:
  ?TODO

# TODO(policy): implement. `sum_pair(ps)` adds up both halves of every record:
# `0n` for none, and a cons cell is its two halves -- first one first -- added to
# the sum of the rest.
def sum_pair(ps: List<&2, P.Pair>) -> Nat:
  ?TODO
