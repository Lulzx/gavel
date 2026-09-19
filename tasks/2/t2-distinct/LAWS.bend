import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no duplicates to remove, so the answer is the empty
# list. Both sides compute, so this is definitional, and it is the absolute
# anchor of `distinct`: the right-hand side mentions no target at all. It is the
# only law that reaches the empty input -- the cons law below names a list with
# at least one element -- so without it a body that answered a constant would
# keep every other law here.
law distinct_nil:
  {S.distinct(Nil{}) == Nil{} : List<Nat>}

# LAW: a cons cell keeps its head -- nothing has been seen before it -- and
# hands the tail to the walk with the head as the one element already seen.
# Definitional, and it is the law that says `distinct` is the *first* occurrence
# that survives: the head is kept before anything is compared with it, and the
# walk that follows it starts with it already seen rather than empty.
law distinct_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.distinct(h <> t) == h <> S.distinct_go(t, h <> Nil{}) : List<Nat>}

# LAW: the walk's empty case is the empty list. Definitional, and it is the pin
# on the answer's shape at the end of the walk: whatever has been seen, there is
# nothing left to keep.
law distinct_go_nil:
  for seen: List<&2, Nat>
  {S.distinct_go(Nil{}, seen) == Nil{} : List<Nat>}

# LAW: the walk's step, and the law with the content. The head is tested against
# what has been seen and then either left out or kept in front of the rest of
# the walk, which carries the head into the seen set -- so a second occurrence
# of the same element is tested against a set that already holds it. The test is
# `P.mem` and the decision is `P.skip_if`, which matches on the value it is
# handed. A body that tested the head against the *previous* element instead, or
# that never added the head to the seen set, is separated here: both would keep
# a duplicate that is not adjacent, or drop one that is.
law distinct_go_step:
  for +h: Nat
  for t: List<&2, Nat>
  for seen: List<&2, Nat>
  {S.distinct_go(h <> t, seen) == P.skip_if(P.mem(seen, h), h, S.distinct_go(t, h <> seen)) : List<Nat>}

# LAW: a walk over a list of `n` equal elements, from a set that already holds
# that element, answers the empty list -- every one of them is a duplicate of
# something already seen. The list is a variable, so this one is the induction,
# and it is the law that fixes what a duplicate contributes: nothing. It is
# stated with the seen set as `k <> seen`, so it holds at every set that holds
# `k`, which is what makes it usable in the step -- the set the walk is left
# with there is one element longer and still of that shape.
law distinct_same_seen:
  for n: Nat
  for k: Nat
  for seen: List<&2, Nat>
  {S.distinct_go(P.same(n, k), k <> seen) == Nil{} : List<Nat>}

# LAW: a list whose head is `k` and whose tail is `m` more copies of `k`
# answers the one element, so every duplicate after the first is gone and the
# first is what is left. This is the law the walk's step and the law above it
# together imply, and it is stated on its own because it is the *answer a user
# reads*: `distinct` of a list of equal elements is the singleton, not the list
# itself and not the empty list. It is stated on the head rather than with
# `P.same` alone so that the empty input is outside it -- the law above is the
# one that covers a list of equal elements with nothing in front.
law distinct_same:
  for m: Nat
  for k: Nat
  {S.distinct(k <> P.same(m, k)) == k <> Nil{} : List<Nat>}

# LAW: one closed list with a duplicate that is not adjacent, answered end to
# end. `[1n, 2n, 1n]` answers `[1n, 2n]`: the third element is dropped, and it is
# dropped because it was seen at the *first* position rather than because it sits
# next to its twin. This is the law that separates this function from `dedup`,
# whose answer here would be the whole list back -- every law above it, including
# the two about lists of equal elements, holds of an adjacent-only body, because
# in a list of equal elements every occurrence is adjacent to its twin.
law distinct_nonadjacent:
  {S.distinct(1n <> 2n <> 1n <> Nil{}) == 1n <> 2n <> Nil{} : List<Nat>}
