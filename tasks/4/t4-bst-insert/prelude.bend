import Base

# A binary search tree: a binary tree of keys plus the invariant that everything
# in a node's left subtree is at most the node's key, and everything in its
# right subtree at least it. This is the task's own type, so the constructors
# are reached through the prelude alias: `P.Tip{}` and `P.Bin{l, key, r}`,
# positionally, in patterns and in terms alike.
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

# The key stored at the root, `0n` at a leaf. A descent has to decide the next
# comparison against the subtree it is about to enter, and that comparison is
# not something a `match` at this level can see; this is the def that produces
# it. The value at a leaf is never consulted, `Tip` taking either branch.
def root_key(t: Tree) -> Nat:
  match t:
    case Tip{}:
      0n
    case Bin{l, key, r}:
      key

# Every key in `t` is at most `b`.
def all_le(t: Tree, +b: Nat) -> Bool:
  match t:
    case Tip{}:
      True{}
    case Bin{l, key, r}:
      Bool.and(le(key, b), Bool.and(all_le(l, b), all_le(r, b)))

# Every key in `t` is at least `b`.
def all_ge(t: Tree, +b: Nat) -> Bool:
  match t:
    case Tip{}:
      True{}
    case Bin{l, key, r}:
      Bool.and(le(b, key), Bool.and(all_ge(l, b), all_ge(r, b)))

# The invariant: at every node the left subtree is bounded above by the key and
# the right subtree below it, and both subtrees are trees of the same kind. It
# is one predicate over the whole tree, recomputed from the root at each step,
# because that is the fact a `match` on the tree exposes.
def ordered(t: Tree) -> Bool:
  match t:
    case Tip{}:
      True{}
    case Bin{+l, +key, +r}:
      Bool.and(all_le(l, key), Bool.and(all_ge(r, key), Bool.and(ordered(l), ordered(r))))

# `1n` when the two numbers are equal, `0n` otherwise, by structural descent on
# both. It returns a `Nat` rather than a `Bool` because the count below adds
# these up, and it has to be a def rather than a `match` on `Nat.is_eq` because
# a `match` cannot scrutinise a computed comparison.
def is_eq(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      match b:
        case 0n:
          1n
        case 1n+q:
          0n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          is_eq(p, q)

# How many keys in `t` are equal to `x` is the policy's `count`; the indicator
# above is the whole of the vocabulary the law needs for it.
