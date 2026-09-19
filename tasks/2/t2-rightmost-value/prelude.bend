import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Leaf{v}`
# and `P.Node{l, key, r}`, in patterns and in terms alike. The two observations
# below are what the third law is stated in terms of: the walk the other way,
# and the tree with its two sides exchanged.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}

# The value at the leftmost leaf: the same walk `rightmost_value` makes, down
# the other side. It matches on its argument, so with a variable tree it does
# not reduce, and that is what leaves the third law below to the induction.
def leftmost(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, key, r}:
      leftmost(l)

# The tree with the two subtrees swapped at every node, the key carried across
# with its node. Same match on its argument, so it too does not reduce on a
# variable.
def mirror(t: Tree) -> Tree:
  match t:
    case Leaf{v}:
      Leaf{v}
    case Node{l, key, r}:
      Node{mirror(r), key, mirror(l)}
