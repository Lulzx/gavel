import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no positions, so the answer is the empty list. Both
# sides compute, so this is definitional, and it is the absolute anchor: the
# right-hand side mentions no target at all. It is also the only law that
# reaches the empty input -- the walk's own empty case is a law below -- so
# without it a body that answered a constant would keep every other law here.
law run_starts_nil:
  {S.run_starts(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: a one-element list opens exactly one run, at position `0n` -- there is no
# element before the first, so it cannot equal one, however large or small it
# is, and `0n` is no exception. Both sides compute, so this is definitional, and
# the right-hand side calls no target. It is the law that separates a body which
# decides the first position by comparing the head with an initial value: such a
# body opens the run on a head that differs from that value and drops it on a
# head that does not.
law run_starts_single:
  for x: Nat
  {S.run_starts(x <> Nil{}) == 0n <> Nil{} : List<&2, Nat>}

# LAW: the walk's empty case has nothing left to open, so it answers the empty
# list, whatever it was carrying. Definitional, and it is the anchor for the
# walk: without it a body that put its position down at the end of every walk
# keeps the step law below.
law run_starts_go_nil:
  for prev: Nat
  for i: Nat
  {S.run_starts_go(Nil{}, prev, i) == Nil{} : List<&2, Nat>}

# LAW: the walk's step compares its head with the element before it, hands that
# answer and its position to the prelude's `P.put_start`, and recurses on the
# tail at the next position with the head as the element before it. Both sides
# compute, so this is definitional, and it is the law with the step: a body that
# carried the position forward without opening a run, or that opened one at
# every position, or that recursed at the same position twice, is separated
# here. The position and the element before it are universally quantified, so
# the law holds at every pair the walk can be started from.
law run_starts_go_cons:
  for +h: Nat
  for t: List<&2, Nat>
  for prev: Nat
  for +i: Nat
  {S.run_starts_go(h <> t, prev, i) == P.put_start(i, S.run_starts_go(t, h, Nat.add(i, 1n)), P.same(h, prev)) : List<&2, Nat>}

# LAW: an element equal to the one before it continues the run it is in, so the
# walk opens nothing at its head and the answer is the walk on the tail one
# position along. This is the law with content: at a variable `a` the decision
# `P.same(a, a)` does not reduce, so the two sides are not the same unfolding --
# the step's answer at `h = prev = a` is a `put_start` on a stuck comparison, and
# only the fact that a number is the same as itself collapses it. A body that
# treated every position as a start leaves this law unconvertible.
law run_starts_go_same:
  for +t: List<&2, Nat>
  for +a: Nat
  for +i: Nat
  {S.run_starts_go(a <> t, a, i) == S.run_starts_go(t, a, Nat.add(i, 1n)) : List<&2, Nat>}

# LAW: one closed list, read end to end. The laws above fix the walk at every
# shape of argument; this one fixes what it comes to on `[1n, 1n, 2n]`, which
# opens a run at `0n` and another at `2n` -- not at `1n`, where the element
# repeats the one before it.
law run_starts_three:
  {S.run_starts(1n <> (1n <> (2n <> Nil{}))) == 0n <> (2n <> Nil{}) : List<&2, Nat>}
