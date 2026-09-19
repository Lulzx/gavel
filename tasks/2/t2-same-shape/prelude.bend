import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias --
# `P.Leaf{v}` and `P.Node{l, key, r}`, in patterns and in terms alike. Every
# node carries a value, a value at a leaf and a key at an interior node, and
# this task's answer ignores both, so the prelude needs nothing beyond the type
# itself and the relabelling the last law compares against.

type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}

# `relabel(t)` is `t` with every value moved on by one: a leaf's value and an
# interior key both become their successor, and the shape is untouched. It sits
# in the prelude rather than in the policy so that the law below is about the
# shape of the tree and not about two functions the policy could define to
# match each other.
def relabel(t: Tree) -> Tree:
  match t:
    case Leaf{v}:
      Leaf{1n + v}
    case Node{l, key, r}:
      Node{relabel(l), 1n + key, relabel(r)}
