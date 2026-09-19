import Base
import ./prelude.bend as P

# The tip case answers `True{}` instead of the accumulator. This is the one body
# in the corpus that `inorder_sorted`'s statement cannot see: the law applies
# `bst` only at `True{}`, and every recursive call inside `bst` passes either
# that same accumulator or `True{}`, so `bst(t, lo, hi, False{})` is never
# instantiated and the body differs from the reference only there.
#
# It is caught anyway, by the proof rather than by a law: `Policy.bst_ind`'s tip
# case has to produce the conjunct `k` from the premise, so a tip that answers
# `True{}` cannot satisfy it at a variable `k`. Recorded here because it is the
# boundary of what this law set states -- the law pins the traversal's order, the
# proof pins the invariant's shape.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.bst_ind`.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(l), key <> inorder(r))

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
      True{}
    case P.Bin{l, +key, r}:
      Bool.and(bst(l, lo, key, k),
               Bool.and(bst(r, key, hi, True{}),
                        Bool.and(P.le(lo, key), P.le(key, hi))))
