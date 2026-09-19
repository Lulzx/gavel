import Base
import ./prelude.bend as P

# TODO(policy): implement. `tree_fold(t, acc)` reads the leaves of `t` into the
# accumulator. Recurse on `t`: a leaf puts its own value in front of the
# accumulator, and a node folds its right subtree first and then folds its left
# subtree onto the result. The accumulator therefore comes out the far end, with
# the tree's leaves in front of it, left to right.
def tree_fold(t: P.Tree, acc: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
