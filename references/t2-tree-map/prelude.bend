import Base

# Immutable, and owned by the task rather than the policy. `Tree` is declared
# here, so its constructors are reached through the prelude alias: `P.Leaf{v}`
# and `P.Node{l, r}`, in patterns and in terms alike. `inc` is supplied by the
# task rather than asked for, so that the laws pin `tree_map` itself instead of
# delegating the leaf function to the policy. `leftmost`, `rightmost` and
# `leaves` are the observations the laws are stated in: the two extreme leaves,
# each descending one side, and the count.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

def inc(x: Nat) -> Nat:
  x + 1n

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

def leaves(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      1n
    case Node{l, r}:
      leaves(l) + leaves(r)
