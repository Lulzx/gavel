import Base
import ./prelude.bend as P
import ./solution.bend as S

law insert_leaf:
  for +k: Nat
  {S.insert(P.Tip{}, k) == P.Bin{P.Tip{}, k, P.Tip{}} : P.Tree}

law insert_le:
  for +x: Nat
  for +y: Nat
  for e: {P.le(y, x) == True{} : Bool}
  {S.insert(P.Bin{P.Tip{}, x, P.Tip{}}, y) == P.Bin{P.Bin{P.Tip{}, y, P.Tip{}}, x, P.Tip{}} : P.Tree}

law insert_gt:
  for +x: Nat
  for +y: Nat
  for e: {P.le(y, x) == False{} : Bool}
  {S.insert(P.Bin{P.Tip{}, x, P.Tip{}}, y) == P.Bin{P.Tip{}, x, P.Bin{P.Tip{}, y, P.Tip{}}} : P.Tree}

# `ins_at` is the stub's first obligation, but no law about `insert` can see it:
# the laws are all equations about `insert` and `count`, and a submission may
# write `insert`'s descent anywhere the gate allows. That is anywhere under
# `Policy.`, which the gate does not check -- so `def Policy.go` carrying the
# real descent, `insert` calling it, and `ins_at` answering its own tree proved
# all five laws at **tier 4, reward 1.000**, measured 2026-09-19.
#
# These three laws are `ins_at`'s definition written out: one case per
# constructor, with both decisions at a node. Together they determine it
# completely, so there is nowhere left for a junk `ins_at` to hide -- a
# submission may still delegate the work to a `Policy.` helper, but `ins_at`
# itself has to be the function the stub asked for.
law ins_at_tip:
  for c: Bool
  for +k: Nat
  {S.ins_at(P.Tip{}, c, k) == P.Bin{P.Tip{}, k, P.Tip{}} : P.Tree}

law ins_at_left:
  for +l: P.Tree
  for key: Nat
  for r: P.Tree
  for +k: Nat
  {S.ins_at(P.Bin{l, key, r}, True{}, k)
     == P.Bin{S.ins_at(l, P.le(k, P.root_key(l)), k), key, r} : P.Tree}

law ins_at_right:
  for l: P.Tree
  for key: Nat
  for +r: P.Tree
  for +k: Nat
  {S.ins_at(P.Bin{l, key, r}, False{}, k)
     == P.Bin{l, key, S.ins_at(r, P.le(k, P.root_key(r)), k)} : P.Tree}

# The invariant law: wherever it went into the tree, the inserted key lands in a
# place that keeps the ordering. The premise is what makes this a conditional
# rather than a falsehood -- an unordered tree need not stay unordered-honest
# under an insert, and the checker is asked to prove the implication, not the
# uncontingent claim.
law insert_ordered:
  for +t: P.Tree
  for +k: Nat
  for e: {P.ordered(t) == True{} : Bool}
  {P.ordered(S.insert(t, k)) == True{} : Bool}

# The multiset law: the count at any key goes up by exactly one when that key is
# the one inserted. `is_eq` is a `Nat` (`1n` or `0n`), so the law is an equation
# between sums of indicators rather than a boolean, and the shape of the answer
# is what rules out a body that counts something else.
law insert_count:
  for +t: P.Tree
  for +k: Nat
  for +x: Nat
  {S.count(S.insert(t, k), x) == S.count(t, x) + P.is_eq(k, x) : Nat}
