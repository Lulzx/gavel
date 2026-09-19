import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no neighbours to compare. Both sides compute, so this
# one is definitional, and it is a pin: it fixes the answer on the empty input,
# which the step law below never reaches.
law dedup_nil:
  {S.dedup(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: a one-element list has no neighbour either, so it answers itself. Both
# sides compute, so this is definitional too. The step law below names
# `a <> (b <> t)`, so it constrains only lists of two or more elements; without
# this one a body that answered a half pair here would satisfy it, and without
# the step law this one would say nothing about any longer list.
law dedup_single:
  for x: Nat
  {S.dedup(x <> Nil{}) == x <> Nil{} : List<&2, Nat>}

# LAW: the step. Two elements or more keep the first exactly when `P.same` says
# the two are different, and continue with the deduplication of everything from
# the second on. Both sides compute, so this is definitional, and it is the law
# that says which elements come out and where the recursion restarts. The
# decision it leaves behind is `P.same(a, b)`, stuck on two variables: a body
# that recursed on `t` alone, or that never dropped a duplicate, or that took
# the two `same_put` answers the wrong way round, leaves the two sides
# unconvertible here.
law dedup_cons:
  for a: Nat
  for b: Nat
  for t: List<&2, Nat>
  {S.dedup(a <> (b <> t)) == P.same_put(a, S.dedup(b <> t), P.same(a, b)) : List<&2, Nat>}

# LAW: equal neighbours collapse, so a run of two equal elements deduplicates to
# the same list as the one that starts at the second. This is the law that is
# not definitional. `dedup_cons` leaves the decision behind `P.same(a, b)`, which
# is stuck on two variables, so it never shows which branch a *concrete* equal
# pair takes; this one instantiates the pair to be equal, and `P.same(a, a)`
# does not reduce on a variable either. The proof is the induction on `a` in
# `Policy.same_refl`.
law dedup_same:
  for a: Nat
  for t: List<&2, Nat>
  {S.dedup(a <> (a <> t)) == S.dedup(a <> t) : List<&2, Nat>}
