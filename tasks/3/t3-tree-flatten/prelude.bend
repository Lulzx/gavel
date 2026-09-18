import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# A binary tree with a number at each leaf. This is the task's own type, so it
# is declared here and the constructors are reached through the prelude alias:
# `P.Leaf{v}` and `P.Node{l, r}`, in patterns and in terms alike.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# The list vocabulary the laws are stated in. All of it is `List<&2, Nat>` so
# that a destructured tail can be marked reusable; `append` and `len` match on
# their first argument, so with a variable list the goals do not reduce.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def snoc(xs: List<&2, Nat>, y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      h <> snoc(t, y)

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      snoc(rev(t), h)

# The number of leaves. It is the measure that `flatten` has to agree with, and
# it is deliberately blind to the order the leaves come out in.
def leaves(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      1n
    case Node{l, r}:
      leaves(l) + leaves(r)

# Mirroring the tree: the pair for `flatten` to be measured against, because
# reversing a flattened list and flattening a mirrored tree give the same list.
def mirror(t: Tree) -> Tree:
  match t:
    case Leaf{v}:
      Leaf{v}
    case Node{l, r}:
      Node{mirror(r), mirror(l)}
