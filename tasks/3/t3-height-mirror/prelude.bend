import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# A binary tree with nothing at the leaves. The shape is the whole content, so
# the height is a function of the branching and not of any value.
type Tree is Data:
  Leaf{}
  Node{l: Tree, r: Tree}

# The mirror image: the two subtrees swapped at every node.
def mirror(t: Tree) -> Tree:
  match t:
    case Leaf{}:
      Leaf{}
    case Node{l, r}:
      Node{mirror(r), mirror(l)}

# The larger of two numbers. It steps on its first argument and then on its
# second, which is what leaves it stuck on a variable: `max(a, b) == max(b, a)`
# is not an unfolding but an induction.
def max(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      match b:
        case 0n:
          1n + p
        case 1n+q:
          1n + max(p, q)
