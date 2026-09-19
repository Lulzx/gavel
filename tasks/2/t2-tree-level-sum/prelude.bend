import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Leaf{v}`
# and `P.Node{l, key, r}`, in patterns and in terms alike. Every node carries a
# value, a key at an interior node and a value at a leaf, which is what makes a
# level sum a sum over both kinds of node.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}

# The value the tree carries at its own root: a leaf's value, a node's key. It
# is here because one law observes the depth-zero sum through it rather than
# through the sum of a subtree.
def root(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, key, r}:
      key
