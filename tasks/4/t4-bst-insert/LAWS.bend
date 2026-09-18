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
