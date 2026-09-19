import Base
import ./prelude.bend as P

# The base case is `False{}` instead of the accumulator, so the whole tree-
# side fold is `False{}` at every tree and the premise of `inorder_all_le`
# is uninhabited -- a vacuity probe rather than a wrong answer. It is the
# proof that catches it: the transport is an induction whose tip case has to
# equate the list fold with `False{}` at an arbitrary accumulator.
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
