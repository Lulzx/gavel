import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the transport -- the tree, the list, and the two folds the
# transport relates. The lemmas that use them are the policy's to write.

# The task's own tree: a number at every node, an empty tree under every leaf.
type Tree is Data:
  Tip{}
  Bin{l: Tree, key: Nat, r: Tree}

def le(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      True{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          le(p, q)

def and(a: Bool, b: Bool) -> Bool:
  match a:
    case True{}:
      b
    case False{}:
      False{}

def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def is_nil(xs: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      False{}

def size(t: Tree) -> Nat:
  match t:
    case Tip{}:
      0n
    case Bin{l, key, r}:
      1n + (size(l) + size(r))

# The list fold: is every element of `xs` at most `b`, given that `k` already
# holds of everything to the left of `xs`? The decision is a parameter rather
# than a `Bool.and` written into the return type, because a `match` cannot
# scrutinise a computed term: the recursion's accumulator *is* computed
# (`le(h, b)`, and below the left subtree's answer), and a parameter can be
# instantiated with a computed term even though a scrutinee cannot.
def bounded_list(xs: List<&2, Nat>, +b: Nat, +k: Bool) -> Bool:
  match xs:
    case Nil{}:
      k
    case h <> t:
      bounded_list(t, b, and(k, le(h, b)))

# The tree fold: the same walk, one node at a time. `k` threads from the left,
# so the left subtree is folded first and its answer becomes the left conjunct
# of the key's comparison. That association is the one an inorder traversal
# produces, and it is what makes the transport below convertible rather than a
# proof about associativity: any other bracketing buys a Boolean algebra.
def bounded(t: Tree, +b: Nat, +k: Bool) -> Bool:
  match t:
    case Tip{}:
      k
    case Bin{l, key, r}:
      bounded(r, b, and(bounded(l, b, k), le(key, b)))
