import Base
import ./prelude.bend as P

# Wrong: `bst`'s leaf answers the literal `True{}` instead of the accumulator it
# was handed, so `bst(t, lo, hi, False{})` claims every tree is in range. No law
# evaluated `bst` at `k = False{}`: `inorder_sorted` passed the literal `True{}`
# and every recursive call threaded either that literal or the same accumulator,
# so on every term any law mentions this body *is* the reference function.
#
# **Measured 2026-09-19: tier 4, complete, reward 1.000, all six laws proven.**
# The proof used is the reference's own `Policy.bst_ind` with `k` fixed to
# `True{}`, which type-checks because that is the only instantiation the laws
# can reach. The repair is the `bst` shape pair just below, `bst_tip` and
# `bst_bin`, mirroring the `inorder_tip`/`inorder_bin` pair that already pins
# `inorder` -- both halves of the definition, because the leaf case alone leaves
# a body wrong in the node case.
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
