import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing to group. Both sides compute, so this one is definitional, and it
# is a pin: it fixes what `chunk_two` answers on the empty input, which no other
# law here reaches.
law chunk_two_nil:
  {S.chunk_two(Nil{}) == Nil{} : List<&2, P.Pair>}

# LAW: a lone element has no partner and is dropped. Both sides compute, so this
# is definitional too, and it is the law that says the odd element is *dropped*
# rather than packed with nothing: a body that answered `P.MkPair{x, x}` here,
# or that kept the element in a pair against a default, leaves the two sides
# unconvertible. `chunk_two_cons` names lists of two or more elements only, so
# neither law covers the other's input.
law chunk_two_single:
  for x: Nat
  {S.chunk_two(x <> Nil{}) == Nil{} : List<&2, P.Pair>}

# LAW: the step. Two elements or more answer the first two grouped together, in
# front of the groups of everything from the *third* element on. Both sides
# compute, so this is definitional, and it is the law that says which element
# lands in which half of a record: it is the only law here that looks inside a
# `P.MkPair`, so a body that built `P.MkPair{y, x}` has the right shape
# everywhere else. It is also the law that says the groups do not overlap -- a
# body that recursed on `y <> t` instead of on `t` repeats elements and answers
# a longer list.
law chunk_two_cons:
  for x: Nat
  for y: Nat
  for t: List<Nat>
  {S.chunk_two(x <> (y <> t)) == P.MkPair{x, y} <> S.chunk_two(t) : List<&2, P.Pair>}

# LAW: nothing to write out. Both sides compute, so this is definitional, and it
# is a pin on `join_two`'s empty case, which the step law below does not reach.
law join_two_nil:
  {S.join_two(Nil{}) == Nil{} : List<Nat>}

# LAW: one record is written out as its two halves, in order, in front of the
# rest. Both sides compute, so this is definitional, and it is the law that says
# the halves come out in the order they were grouped: a body that answered
# `b <> (a <> join_two(t))` is caught here and nowhere else, since every other
# law about `join_two` either has an empty list or is stated over the round trip
# with `chunk_two`, which would have to be wrong in the matching way.
law join_two_cons:
  for a: Nat
  for b: Nat
  for t: List<&2, P.Pair>
  {S.join_two(P.MkPair{a, b} <> t) == a <> (b <> S.join_two(t)) : List<Nat>}

# LAW: the round trip, and the work. Writing the records out and grouping the
# result again is the identity on a list of records: a list that is already
# grouped has no unpaired element to lose, which is what makes this direction
# total where the other one is not. Neither side computes on a variable `ps` --
# `join_two` is stuck until its argument is a cons, and `chunk_two` is stuck
# until the list it is handed is one -- so the two sides are not convertible and
# the induction is the proof. This is the law that pins both functions at once:
# a `join_two` that dropped a half and a `chunk_two` that duplicated one can
# agree on every law above and still disagree here.
law chunk_two_join_two:
  for ps: List<&2, P.Pair>
  {S.chunk_two(S.join_two(ps)) == ps : List<&2, P.Pair>}
