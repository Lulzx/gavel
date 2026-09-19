import Base
import ./prelude.bend as P

# Mutant: the leaf case answers `0n` instead of `1n` -- a leaf counts as no
# leaf. Type-checks, and it is the anchor law that catches it: the step law is
# stated at `P.Node{l, r}` and never reaches a leaf.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_leaf_count_leaf, tree_leaf_count_flatten.
def tree_leaf_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, r}:
      tree_leaf_count(l) + tree_leaf_count(r)
