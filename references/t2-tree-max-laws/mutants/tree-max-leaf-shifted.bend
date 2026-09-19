import Base
import ./prelude.bend as P

# Mutant: the leaf case answers one more than the number the leaf carries, so
# the reading is the largest number in the tree plus one. Type-checks, and it is
# the anchor law that catches it: no tree's answer may be a function of the
# leaf's value other than the value itself.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_max_leaf, tree_max_flatten.
def tree_max(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      1n + v
    case P.Node{l, r}:
      P.max(tree_max(l), tree_max(r))
