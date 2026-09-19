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

# The same pair for `bst`, and they are here for a measured reason rather than
# symmetry. `inorder_sorted` below was for a long time the only law naming
# `bst`, and it instantiates the accumulator at the literal `True{}`: every
# recursive `bst` call threads either that literal or the same accumulator, so
# the leaf's `False{}` branch is unreachable from every law. A `bst` whose tip
# answers `True{}` instead of the accumulator is therefore the reference
# function on every term any law mentions, and it would have earned a full
# reward. **Measured 2026-09-19: tier 4, complete, reward 1.000, all six laws**
# -- the escape is `mutants/bst-tip-ignores-the-accumulator.bend`. The pair is
# the repair, exactly as the pair above is for `inorder`: the leaf pins the
# accumulator, the node pins the combination, and one without the other leaves
# a body wrong in the other case. `{==}` proves both.
law bst_tip:
  for lo: Nat
  for hi: Nat
  for k: Bool
  {S.bst(P.Tip{}, lo, hi, k) == k : Bool}

law bst_bin:
  for +l: P.Tree
  for +key: Nat
  for +r: P.Tree
  for +lo: Nat
  for +hi: Nat
  for +k: Bool
  {S.bst(P.Bin{l, key, r}, lo, hi, k) == Bool.and(S.bst(l, lo, key, k), Bool.and(S.bst(r, key, hi, True{}), Bool.and(P.le(lo, key), P.le(key, hi)))) : Bool}

# The same pair a third time, for the two bound folds -- and this one is not
# symmetry. Neither `all_le_put` nor `all_ge_put` was named on the left of any
# law: both occurred *only* inside the premises of `inorder_all_le` /
# `inorder_all_ge` below. A submission whose `all_le_put` answers `False{}` at
# every input reduces that premise to `{False{} == True{}}`, which makes the
# transport law vacuous, and the two-line discharge
# `Policy.absurd_true(P.all_le_list_put(S.inorder(t), b, k), e)` is then a
# complete proof of it. **Measured 2026-09-19: tier 4, complete, reward 1.000,
# all eight laws** for exactly that body -- the probe is
# `/tmp/esc/t4/solution.bend`, and it is the `all_le_put-answers-false.bend`
# mutant below paired with its own proof rather than the reference's. That
# pairing is the whole point: the reference proof is not the test, the policy
# writes its own. The lesson generalises past this task: a target that a law bag
# mentions *only* in a premise is a target no law constrains, because the
# submission controls whether the premise is inhabitable at all.
#
# The pair is the repair. `all_le_put_tip` alone is not enough and the reason is
# worth keeping: it kills the constant body, which is wrong at the tip, but a
# body wrong only at a node still makes the premise falsely uninhabitable there
# and the law still proves vacuously. The node law is what makes the premise
# *inhabitable rather than merely unfalsifiable*, so it has to be present for
# the transport to say anything. One without the other leaves a body wrong in
# the other case; `{==}` proves all four.
law all_le_put_tip:
  for b: Nat
  for k: Bool
  {S.all_le_put(P.Tip{}, b, k) == k : Bool}

law all_le_put_bin:
  for +l: P.Tree
  for +key: Nat
  for +r: P.Tree
  for +b: Nat
  for +k: Bool
  {S.all_le_put(P.Bin{l, key, r}, b, k) == S.all_le_put(r, b, Bool.and(S.all_le_put(l, b, k), P.le(key, b))) : Bool}

law all_ge_put_tip:
  for b: Nat
  for k: Bool
  {S.all_ge_put(P.Tip{}, b, k) == k : Bool}

law all_ge_put_bin:
  for +l: P.Tree
  for +key: Nat
  for +r: P.Tree
  for +b: Nat
  for +k: Bool
  {S.all_ge_put(P.Bin{l, key, r}, b, k) == S.all_ge_put(r, b, Bool.and(S.all_ge_put(l, b, k), P.le(b, key))) : Bool}

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
# it vacuous *by changing the shape of `bst`*: a body that drops a conjunct
# changes the shape of `S.bst(t, lo, hi, True{})` and the projections stop
# type-checking, and a body that keeps the shape but changes which bound goes
# where cannot close the induction. Measured 2026-09-19: all four `bst` mutants
# measured failed at `Policy.bst_ind`, none of them here.
#
# **That argument was too strong, and the `bst_tip`/`bst_bin` pair above is the
# correction.** It reasons about the *reference* proof, and the reference proof
# is not the test: the policy writes its own. The counterexample is a body that
# keeps the shape and changes nothing the law can see -- a leaf answering
# `True{}` instead of the accumulator -- which is the reference function on
# every term this law and every other mentions, and which read tier 4 with
# reward 1.000 under a `k`-specialised induction. This law pins the traversal's
# order given the invariant; the pair above pins the invariant. Neither implies
# the other.
law inorder_sorted:
  for +t: P.Tree
  for +lo: Nat
  for +hi: Nat
  for e: {S.bst(t, lo, hi, True{}) == True{} : Bool}
  {P.sorted_put(S.inorder(t), lo, True{}) == True{} : Bool}
