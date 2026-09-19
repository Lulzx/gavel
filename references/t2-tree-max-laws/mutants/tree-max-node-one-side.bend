import Base
import ./prelude.bend as P

# Mutant: the node case descends the left subtree only, so the numbers in the
# right subtree are never read. The leaf case is untouched, so the anchor law
# holds; the step law catches it -- one side is `tree_max(l)` and the other is
# `P.max(tree_max(l), tree_max(r))`, and neither is convertible.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# tree_max_node, tree_max_flatten.
def tree_max(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, r}:
      tree_max(l)
