import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the outer list; the empty list of lists
# flattens to the empty list, and a cons cell's head is appended to the
# concatenation of its tail. `append` comes from the prelude.
def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  ?TODO
