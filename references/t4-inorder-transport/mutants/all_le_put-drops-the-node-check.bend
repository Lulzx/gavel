import Base
import ./prelude.bend as P

# The comparison at the node is gone: both subtrees are folded and the
# accumulator is threaded, but `le(key, b)` is never conjoined. A tree whose
# keys are all above `b` answers `True{}`, so the premise of
# `inorder_all_le` holds and its conclusion does not.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.all_le_put_transport`.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(l), key <> inorder(r))

# The tree side of the bound, threaded left to right so the fold's association
# mirrors the traversal's.
def all_le_put(t: P.Tree, +b: Nat, +k: Bool) -> Bool:
  match t:
    case P.Tip{}:
      k
    case P.Bin{l, +key, r}:
      all_le_put(r, b, all_le_put(l, b, k))

def all_ge_put(t: P.Tree, +b: Nat, +k: Bool) -> Bool:
  match t:
    case P.Tip{}:
      k
    case P.Bin{l, +key, r}:
      all_ge_put(r, b, Bool.and(all_ge_put(l, b, k), P.le(b, key)))

# The range invariant a sorted traversal comes from.
def bst(t: P.Tree, +lo: Nat, +hi: Nat, k: Bool) -> Bool:
  match t:
    case P.Tip{}:
      k
    case P.Bin{l, +key, r}:
      Bool.and(bst(l, lo, key, k),
               Bool.and(bst(r, key, hi, True{}),
                        Bool.and(P.le(lo, key), P.le(key, hi))))
