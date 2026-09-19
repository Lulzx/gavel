import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `t`. A leaf becomes a node whose left
# child is that leaf and whose right child is a new `P.Leaf{v}`; a node hands
# its left subtree back untouched and rebuilds itself around the recursive call
# on its right subtree. The new leaf therefore lands at the bottom of the right
# spine, not on top of the tree.
def snoc_tree(t: P.Tree, v: Nat) -> P.Tree:
  ?TODO
