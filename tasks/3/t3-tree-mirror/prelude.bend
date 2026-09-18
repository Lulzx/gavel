import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# A binary tree with a number at each leaf. This is the task's own type, so it
# is declared here and the constructors are reached through the prelude alias:
# `P.Leaf{v}` and `P.Node{l, r}`, in patterns and in terms alike.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# The number of leaves.
def size(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, r}:
      size(l) + size(r)

# The value at the leftmost leaf, and at the rightmost one. They are the pair
# that tells a tree from its mirror image: on the whole tree they differ,
# whereas on a mirrored one they swap. Each steps on its own side, so only one
# of the two subtrees is live in a given branch.
def leftmost(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, r}:
      leftmost(l)

def rightmost(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, r}:
      rightmost(r)
