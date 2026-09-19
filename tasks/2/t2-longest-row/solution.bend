import Base
import ./prelude.bend as P

# TODO(policy): implement. `map_len(xss)` is the list of the lengths of the rows,
# in the order the rows appear: `Nil{}` is `Nil{}`, and a cons cell is the length
# of its first row (`P.len`) in front of the same function on the remaining rows.
def map_len(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  ?TODO

# TODO(policy): implement. `longest_row(xss)` is the length of the longest row,
# and `0n` when there are no rows: a cons cell is the larger of the first row's
# length and the longest of the rest, which is `P.max`.
def longest_row(xss: List<&2, List<&2, Nat>>) -> Nat:
  ?TODO
