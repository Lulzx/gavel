import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Leaf{v}`
# and `P.Node{l, key, r}`, in patterns and in terms alike. A leaf carries a
# value and an interior node carries a key, and this task's answer weighs both
# by how many leaves sit under them, so the prelude also carries the two counts
# a node's key is multiplied by.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}

# `leaves(t)` counts the leaves of `t` -- one for a leaf, and the two subtrees'
# counts added at a node. It matches on its argument, so with a variable tree
# the result does not reduce: that a node has two leaves under it is a fact
# about its shape and not an unfolding.
def leaves(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      1n
    case Node{l, key, r}:
      Nat.add(leaves(l), leaves(r))

# `zeroed(t)` is `t` with every value dropped to zero -- a leaf's value and an
# interior key alike, the shape untouched. Same match on its argument, so with a
# variable tree it too does not reduce.
def zeroed(t: Tree) -> Tree:
  match t:
    case Leaf{v}:
      Leaf{0n}
    case Node{l, key, r}:
      Node{zeroed(l), 0n, zeroed(r)}
