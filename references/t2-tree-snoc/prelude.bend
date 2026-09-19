import Base

# The task's own tree, declared here and not in `solution.bend`: the policy
# never has to name a constructor context, and the type is the same one the
# laws and the reference proof quantify over.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# The value at the leftmost leaf, descending the left spine.
def leftmost(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, r}:
      leftmost(l)

# The value at the rightmost leaf, descending the right spine.
def rightmost(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, r}:
      rightmost(r)

# How many nodes the right spine has: one for the leaf it ends at, one for each
# `Node` it passes through. `leftmost` and `rightmost` read a value off a
# spine; this counts one, so it can tell two trees with the same leaves and the
# same extreme values apart.
def right_spine(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      1n
    case Node{l, r}:
      1n + right_spine(r)
