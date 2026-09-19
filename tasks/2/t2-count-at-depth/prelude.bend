import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Tip{}`
# and `P.Bin{l, key, r}`, in patterns and in terms alike.
#
# `P.Tip{}` is the empty tree: it is not a node and it carries no key, so a tip
# holds no node at any depth. A `P.Bin{l, key, r}` is one node, with a key of its
# own between its two subtrees, so a count of nodes at a depth is a count of the
# `Bin`s and nothing else. That is the whole of what makes this a different
# function from `tree_level_sum`, which adds the keys up, and from
# `leaf_count_at`, which counts one kind of node of a value-carrying tree.
type Tree is Data:
  Tip{}
  Bin{l: Tree, key: Nat, r: Tree}

# Whether the tree is a tip. It is here because one law observes the depth-zero
# count through it rather than through the recursion: a tip is not a node and a
# bin is one, and that is the whole of what depth zero has to say about a count.
def is_tip(t: Tree) -> Bool:
  match t:
    case Tip{}:
      True{}
    case Bin{l, key, r}:
      False{}

# One of two answers, taken on a decision. It matches on its *parameter*, which
# is why the law about depth zero can name the count at a tip and at a bin
# without matching where the tree is a variable.
def at_if(b: Bool, x: Nat, y: Nat) -> Nat:
  match b:
    case True{}:
      x
    case False{}:
      y
