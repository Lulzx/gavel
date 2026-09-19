import Base
import ./prelude.bend as P

# The traversal answers the empty list at every node: the tree is matched
# and then ignored. `inorder_tip` still holds -- there is no key to lose --
# while `inorder_bin` is false of it at any node.
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
    case P.Bin{+l, +key, +r}:
      Nil{}

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
