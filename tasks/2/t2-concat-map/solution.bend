import Base
import ./prelude.bend as P

# TODO(policy): implement. `concat_map(xs)` is the map and the flatten in one
# pass: the empty list gives the empty list, and a cons cell expands its head
# with `P.expand` and appends the concatenation of its tail. `append` comes
# from the prelude.
def concat_map(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
