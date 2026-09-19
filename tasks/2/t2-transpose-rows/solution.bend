import Base
import ./prelude.bend as P

# TODO(policy): implement. `insert_row(r, cols)` conses the elements of `r`
# onto the front of the columns in `cols`, in order; an element whose column
# does not exist yet starts a new one-element column. `transpose(rows)` is the
# fold that inserts the first row into the transpose of the rest.
def insert_row(r: List<&2, Nat>, cols: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  ?TODO

# TODO(policy): implement. `transpose(rows)` returns the matrix whose columns
# are the rows of `rows`. The empty matrix transposes to the empty matrix, and
# a matrix whose first row is `r` and whose rest is `rs` transposes by inserting
# `r` into the transpose of `rs`.
def transpose(rows: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  ?TODO
