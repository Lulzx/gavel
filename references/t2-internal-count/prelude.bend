import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Leaf{v}`
# and `P.Node{l, key, r}`, in patterns and in terms alike. Everything else here
# is what the third law is stated in terms of; that law and not the recursion
# reads the interior nodes.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}

# `xs` followed by `ys`. It matches on its first argument, so with a variable
# list the goal does not reduce, and that is what leaves the third law below to
# the induction rather than to an unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# How many elements a list has.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The keys of the interior nodes, root first: a leaf contributes nothing at all,
# and a node's own key comes in front of its two subtrees' entries, left
# subtree first. One entry per interior node, so its length is that count.
def inner(t: Tree) -> List<&2, Nat>:
  match t:
    case Leaf{v}:
      Nil{}
    case Node{l, key, r}:
      key <> append(inner(l), inner(r))
