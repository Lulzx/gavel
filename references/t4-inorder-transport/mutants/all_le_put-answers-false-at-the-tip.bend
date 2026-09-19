import Base
import ./prelude.bend as P

# The tip is `False{}` instead of the accumulator, so the whole tree-side fold
# is `False{}` at every tree and the premise of `inorder_all_le` is uninhabited
# -- a vacuity probe rather than a wrong answer.
#
# **This file is the regression witness for a hole that was open until
# 2026-09-19, and the reading an earlier version of this comment recorded is
# exactly what it warns about.** Against the *reference* proof it reads
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.all_le_put_transport` -- and that reading was misleading, because the
# reference proof is not the test. The policy writes its own. Paired with the
# two-line discharge
# `Policy.absurd_true(P.all_le_list_put(S.inorder(t), b, k), e)` in place of
# `L.inorder_all_le`, this same body reached **tier 4, complete, reward 1.000,
# all eight laws**. `all_le_put` was named by no law's left-hand side -- it
# occurred only inside the premise above -- so nothing constrained it, and
# falsifying the premise turned the transport into a tautology the submission
# could discharge however it liked.
#
# The repair is `all_le_put_tip` / `all_le_put_bin` and the matching
# `all_ge_put` pair in `LAWS.bend`. The general rule, which is worth more than
# the fix: a target a law set mentions *only* inside a premise is a target the
# law set does not constrain, because the submission decides whether the
# premise is inhabitable. Measured after the repair: the same bespoke pairing
# drops to **tier 3**, failing `all_le_put_tip` and `all_le_put_bin`, while the
# reference still reads tier 4.
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
      False{}
    case P.Bin{l, +key, r}:
      all_le_put(r, b, Bool.and(all_le_put(l, b, k), P.le(key, b)))

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
