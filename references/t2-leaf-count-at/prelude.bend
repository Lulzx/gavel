import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Leaf{v}`
# and `P.Node{l, key, r}`, in patterns and in terms alike. The number at a leaf
# is a value the tree carries, and it is not a leaf of its own: a leaf is one
# leaf, and an interior node is not a leaf at all, which is what makes a leaf
# count a count over one kind of node only.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}

# Whether the tree is a leaf. It is here because one law observes the depth-zero
# count through it rather than through the recursion: a leaf is one leaf and an
# interior node is not a leaf at all, and that is the whole of what depth zero
# has to say about a count.
def is_leaf(t: Tree) -> Bool:
  match t:
    case Leaf{v}:
      True{}
    case Node{l, key, r}:
      False{}

# One of two answers, taken on a decision. It matches on its *parameter*, which
# is why the law about depth zero can name the count at a leaf and at a node
# without matching where the tree is a variable.
def at_if(b: Bool, x: Nat, y: Nat) -> Nat:
  match b:
    case True{}:
      x
    case False{}:
      y

# The tree with its two subtrees swapped at every node; leaves are unchanged.
# The values and the shape are the originals, and one law below is the statement
# that a count of leaves at a depth cannot see the difference.
def mirror(t: Tree) -> Tree:
  match t:
    case Leaf{v}:
      Leaf{v}
    case Node{l, key, r}:
      Node{mirror(r), key, mirror(l)}
