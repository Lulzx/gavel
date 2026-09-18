import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# A binary tree with a number at every node. The key sits between the two
# subtrees, so a mirror has to carry it across as well as swapping them.
type Tree is Data:
  Leaf{}
  Node{l: Tree, key: Nat, r: Tree}

# The mirror image: the two subtrees swapped at every node, with the key kept
# where it is in the node.
def mirror(t: Tree) -> Tree:
  match t:
    case Leaf{}:
      Leaf{}
    case Node{l, key, r}:
      Node{mirror(r), key, mirror(l)}
