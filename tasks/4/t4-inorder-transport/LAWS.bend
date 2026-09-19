import Base
import ./prelude.bend as P
import ./solution.bend as S

# A LAWS.bend on its own proves nothing: the checker reads these declarations
# only because PROOF.bend imports this file, and every one of the six is a
# `def L.<name>` the submission has to write. A law is a claim about the
# submission, not about the file it is written in.

# The two shape pins: what the traversal produces at the bottom and at a node.
# They are the reference's own unfolding, so between them they determine
# `inorder` outright -- but they have to be here as laws anyway, because
# `inorder` is a policy target and the pins are what make the stub's first
# obligation an obligation. The proof is `{==}` on both, which is the honest
# proof of a definitional equation.
law inorder_tip:
  {S.inorder(P.Tip{}) == Nil{} : List<&2, Nat>}

law inorder_bin:
  for +l: P.Tree
  for +key: Nat
  for +r: P.Tree
  {S.inorder(P.Bin{l, key, r}) == P.append(S.inorder(l), key <> S.inorder(r)) : List<&2, Nat>}

# The traversal visits each node exactly once: a measure law. Blind to order,
# so the arithmetic carries it rather than the tree induction. It is implied by
# the two pins above, and it is kept anyway: the laws are also the readable
# statement of what the function is, and a measure law is the bank's way of
# saying "one element per node" in a form a reader can check without unfolding
# an append. t4-nth-maybe set the same precedent with `nth_some`.
law inorder_len:
  for +t: P.Tree
  {P.len(S.inorder(t)) == P.size(t) : Nat}

# The transports: a bound on the tree becomes a bound on the list the traversal
# produces -- two structures, one fact moved between them. The premise names the
# tree-side fold, the conclusion the list-side one, and the two folds thread
# their accumulators left to right so that the traversal's association is the
# fold's. A `Bool.and`-associating pair of folds would make this false for the
# same reason the fold in the prelude is left-threading.
law inorder_all_le:
  for +t: P.Tree
  for +b: Nat
  for +k: Bool
  for e: {S.all_le_put(t, b, k) == True{} : Bool}
  {P.all_le_list_put(S.inorder(t), b, k) == True{} : Bool}

law inorder_all_ge:
  for +t: P.Tree
  for +b: Nat
  for +k: Bool
  for e: {S.all_ge_put(t, b, k) == True{} : Bool}
  {P.all_ge_list_put(S.inorder(t), b, k) == True{} : Bool}

# The order-sensitive half: the BST range invariant implies the traversal is
# sorted. The invariant's subject is the tree, the conclusion's is the list, and
# a traversal that visits the right subtree first answers a different list.
#
# This law is what the `bst` target is for, and it is also the one whose weight
# is easiest to overstate. The premise is not vacuous, and a mutant cannot make
# it vacuous: `bst` is a policy target, but the reference proof reads the
# invariant through `Policy.bst_ind`, which projects its conjuncts with
# `Policy.and_l`/`and_r`. A body that drops a conjunct changes the shape of
# `S.bst(t, lo, hi, True{})` and the projections stop type-checking; a body that
# keeps the shape but changes which bound goes where leaves the projections
# standing but cannot close the induction. Either way the submission falls to
# tier 2 with nothing proven, rather than satisfying this law's premise
# trivially. Measured 2026-09-19: all four `bst` mutants measured failed at
# `Policy.bst_ind`, none of them here.
law inorder_sorted:
  for +t: P.Tree
  for +lo: Nat
  for +hi: Nat
  for e: {S.bst(t, lo, hi, True{}) == True{} : Bool}
  {P.sorted_put(S.inorder(t), lo, True{}) == True{} : Bool}
