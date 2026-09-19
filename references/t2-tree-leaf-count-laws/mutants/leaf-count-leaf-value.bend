import Base
import ./prelude.bend as P

# Mutant: the leaf case answers the value the leaf carries, so the reading is a
# sum of stored numbers rather than a count of leaves. Type-checks, and the
# anchor law catches it: at `P.Leaf{v}` the answer must be `1n` whatever `v` is.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_leaf_count_leaf, tree_leaf_count_flatten.
def tree_leaf_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, r}:
      tree_leaf_count(l) + tree_leaf_count(r)
