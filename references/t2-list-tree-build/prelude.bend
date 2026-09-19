import Base

# The task's own tree, declared here and not in `solution.bend`: the policy
# never has to name a constructor context, and the type is the same one the
# laws and the reference proof quantify over.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, r: Tree}

# How many elements a list of numbers has. `List.length` in `Base` wants the
# element kind spelled out, which is noise in a law statement.
def len(bs: List<&2, Nat>) -> Nat:
  match bs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# How many leaves the tree has.
def leaves(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      1n
    case Node{l, r}:
      leaves(l) + leaves(r)

# How many nodes the right spine has: one for the leaf it ends at, one for each
# `Node` it passes through. A tree whose leaves all sit on its right spine has
# exactly one spine node per leaf, and that is what tells a left-leaning tree
# from a right-leaning one built out of the same list.
def right_spine(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      1n
    case Node{l, r}:
      1n + right_spine(r)

# The value at the rightmost leaf, descending the right spine.
def rightmost(t: Tree) -> Nat:
  match t:
    case Leaf{v}:
      v
    case Node{l, r}:
      rightmost(r)

# The last element of a list, and zero when there is none. It is a fold that
# walks the list to its end and answers what it found there, so it observes
# exactly the value the bottom of a right spine would carry.
def last_or_zero(bs: List<&2, Nat>) -> Nat:
  match bs:
    case Nil{}:
      0n
    case h <> t:
      last_or_zero(t)
