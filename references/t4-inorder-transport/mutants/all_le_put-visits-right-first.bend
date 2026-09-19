import Base
import ./prelude.bend as P

# The two subtree folds are exchanged, so the accumulator is threaded right
# to left while the list-side fold threads left to right. The conjunction is
# commutative, so the value agrees at the root and differs wherever the
# accumulator is not `True{}`; `inorder_all_le` is the law that sees it.
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
      all_le_put(l, b, Bool.and(all_le_put(r, b, k), P.le(key, b)))

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
