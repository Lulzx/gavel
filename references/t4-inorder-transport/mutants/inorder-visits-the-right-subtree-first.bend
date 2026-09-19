import Base
import ./prelude.bend as P

# The node's key is still between the two traversals, but the right subtree
# is visited first, so the list comes back in descending order. It
# contradicts `inorder_bin`, and it is also the body `inorder_sorted` is
# stated for: the range invariant is untouched, so its premise holds of a
# tree this body reverses.
# Every isolation run carries the reference's `Policy.*` helpers, and the
# transport helpers spell `inorder`'s unfolding out in their own types
# (`P.append(S.inorder(l), key <> S.inorder(r))`), so a body that changes
# `inorder` leaves a helper that no longer type-checks and nothing is
# proven. The law this body contradicts is named above; the first failure
# the checker reports is the helper.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.all_le_put_transport`.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(r), key <> inorder(l))

def all_le_put(t: P.Tree, +b: Nat, +k: Bool) -> Bool:
  match t:
    case P.Tip{}:
      k
    case P.Bin{l, +key, r}:
      all_le_put(r, b, Bool.and(all_le_put(l, b, k), P.le(key, b)))

def all_ge_put(t: P.Tree, +b: Nat, +k: Bool) -> Bool:
  match t:
    case P.Tip{}:
      k
    case P.Bin{l, +key, r}:
      all_ge_put(r, b, Bool.and(all_ge_put(l, b, k), P.le(b, key)))

def bst(t: P.Tree, +lo: Nat, +hi: Nat, k: Bool) -> Bool:
  match t:
    case P.Tip{}:
      k
    case P.Bin{l, +key, r}:
      Bool.and(bst(l, lo, key, k),
               Bool.and(bst(r, key, hi, True{}),
                        Bool.and(P.le(lo, key), P.le(key, hi))))
