import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no position to report, and the answer says so with
# `0n`. Both sides compute, so this is definitional, and it is the absolute
# anchor of `argmax`: the right-hand side mentions no target at all. It is the
# only law that reaches the empty input -- the cons law below names a list with
# at least one element -- so without it a body that answered a constant would
# keep every other law here.
law argmax_nil:
  {S.argmax(Nil{}) == 0n : Nat}

# LAW: a cons cell hands its tail to the walk, with the head as the largest seen
# so far, `0n` as the position of that largest, and `1n` as the position the
# tail starts at. Definitional, and it is the law that says `argmax` is the walk
# started at the head rather than at a constant or at the last element: a body
# that seeded the walk with `0n` twice answers `0n` here on a one-element list
# and keeps every other law.
law argmax_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.argmax(h <> t) == S.argmax_go(t, h, 0n, 1n) : Nat}

# LAW: the walk's empty case is the position of the largest element it has seen,
# which is the second of its running values. Definitional, and it is the pin on
# the walk: with the step law below it fixes which of the running values is the
# answer, so a body that answered the position counter here keeps the step law
# and loses this one.
law argmax_go_nil:
  for cur: Nat
  for bi: Nat
  for i: Nat
  {S.argmax_go(Nil{}, cur, bi, i) == bi : Nat}

# LAW: the walk's step folds the head into both running values and recurses on
# the tail. Definitional, and it is the law with the content: the new largest is
# `P.max2(h, cur)`, and the new position is `i` if the head is strictly greater
# than the largest seen so far and `bi` otherwise. The comparison is strict, so
# a head that merely ties with the largest seen so far does not move the
# position -- which is what makes the answer the *first* position of the largest
# element. A body that took the new position on a tie is separated here while
# keeping the two laws above, and a body that dropped the head entirely answers
# the starting position and is separated here too. The running values are
# universally quantified, so the law holds at every state the walk can be
# started from, not only at the one `argmax` starts it with.
law argmax_go_step:
  for +h: Nat
  for t: List<&2, Nat>
  for +cur: Nat
  for bi: Nat
  for +i: Nat
  {S.argmax_go(h <> t, cur, bi, i) == S.argmax_go(t, P.max2(h, cur), P.pick_if(P.gt(h, cur), i, bi), 1n + i) : Nat}

# LAW: one closed list, answered end to end. The laws above fix the walk at
# every shape of argument; this one fixes what the walk comes to on
# `[1n, 3n, 2n]`, whose largest element is `3n` and sits at position `1n` -- not
# at `0n`, where the walk starts, and not at `2n`, where it ends.
law argmax_three:
  {S.argmax(1n <> 3n <> 2n <> Nil{}) == 1n : Nat}

# LAW: a closed list with a tie in it. The largest element is `3n`, at positions
# `1n` and `2n`; the answer is `1n`, the first of them. This is the law the
# closed `argmax_three` above cannot be: that list has no tie, so a body that
# moved the position every time the head reached the largest seen so far would
# keep it. Here such a body answers `2n`.
law argmax_tie:
  {S.argmax(2n <> 3n <> 3n <> 1n <> Nil{}) == 1n : Nat}

# LAW: the walk over a list of equal elements, from a state whose largest seen
# so far is that element, answers the position it started from -- whatever the
# counter reads. The list is a variable, so this one is the induction: every
# element ties with the largest seen so far, so the step law leaves the position
# untouched at every one of them, and the tie is never decided in the body's
# favour. A body that took the new position on a tie answers `n` rather than the
# position it started from, and a body that answered the position counter at the
# empty list answers `n` too -- this is the law that separates both from the
# walk. Its state is universally quantified, so it holds at every state the walk
# can be started from, and it is the only law whose left-hand side is neither a
# cons cell nor a closed list.
law argmax_same:
  for n: Nat
  for k: Nat
  for bi: Nat
  for i: Nat
  {S.argmax_go(P.same(n, k), k, bi, i) == bi : Nat}
