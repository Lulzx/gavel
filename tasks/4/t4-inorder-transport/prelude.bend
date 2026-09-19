import Base

# A binary search tree: a binary tree of keys. This is the task's own type, so
# the constructors are reached through the prelude alias: `P.Tip{}` and
# `P.Bin{l, key, r}`, positionally, in patterns and in terms alike.
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

# How many nodes the tree has. The measure the traversal has to match, one
# node per element, so `size` is the number the `len` law compares against.
def size(t: Tree) -> Nat:
  match t:
    case Tip{}:
      0n
    case Bin{l, key, r}:
      1n + (size(l) + size(r))

# Sortedness as a left-threading fold: `k` is the answer for the part of the
# list already walked, and the element before the hole is passed along. The
# shape is verbatim from t3-isort-sorted, so that a traversal can be asked for
# a sortedness continuation directly, without a separate seed-valued predicate
# that the fold would then have to agree with.
def sorted_put(t: List<&2, Nat>, +h: Nat, k: Bool) -> Bool:
  match t:
    case Nil{}:
      k
    case +h2 <> t2:
      match k:
        case False{}:
          False{}
        case True{}:
          sorted_put(t2, h2, le(h, h2))

# The seed-valued form of the same predicate, for reading.
def is_sorted(xs: List<&2, Nat>) -> Bool:
  sorted_put(xs, 0n, True{})

# Seedless conjunction bounds on a list. These are the statements a reader
# wants -- "every element is at most b" -- and the two folds below are the same
# facts written so that their association can mirror the traversal's.
def all_le_list(xs: List<&2, Nat>, +b: Nat) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(le(h, b), all_le_list(t, b))

def all_ge_list(xs: List<&2, Nat>, +b: Nat) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.and(le(b, h), all_ge_list(t, b))

# The same two bounds as left-threading folds over an accumulator, so that the
# list fold and the tree fold can be walked in the same order and the transport
# is one induction rather than a reassociation proof.
def all_le_list_put(xs: List<&2, Nat>, +b: Nat, +k: Bool) -> Bool:
  match xs:
    case Nil{}:
      k
    case h <> t:
      all_le_list_put(t, b, Bool.and(k, le(h, b)))

def all_ge_list_put(xs: List<&2, Nat>, +b: Nat, +k: Bool) -> Bool:
  match xs:
    case Nil{}:
      k
    case h <> t:
      all_ge_list_put(t, b, Bool.and(k, le(b, h)))
