import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no element at any distance from its end, so the answer
# is the default. Both sides compute, so this is definitional, and it is the
# absolute anchor of `nth_from_end`: the right-hand side mentions no target at
# all, and it is the only law that reaches the empty input -- the step law below
# names a list with at least one element.
law nth_from_end_nil:
  for k: Nat
  for d: Nat
  {S.nth_from_end(Nil{}, k, d) == d : Nat}

# LAW: the step. A cons cell answers its head when its *tail* holds `k`
# elements, and otherwise recurses on the tail. Both sides compute, so this is
# definitional, and it is the law that says what the distance is measured in:
# `P.len(t)` counts the elements after the head, so the last element is `0n`
# positions from the end and the one before it is `1n`. The test is `P.eq` and
# the decision is taken by `P.pick_if`, which the law names because the test is a
# computed value -- a match cannot scrutinise a computed value where it is
# written. A body that measured the whole list rather than the tail is separated
# here, and so is one that took the head on the test's *false* side. The law is
# stated at variables, so it holds at every list and every distance.
law nth_from_end_step:
  for h: Nat
  for t: List<&2, Nat>
  for k: Nat
  for d: Nat
  {S.nth_from_end(h <> t, k, d) == P.pick_if(P.eq(P.len(t), k), h, S.nth_from_end(t, k, d)) : Nat}

# LAW: the element of a two-element list that is `0n` positions from its end --
# the last one. The elements are two different variables, so the law says
# *which* of them is answered: a body that took the head when the tail is short
# enough answers `x` here and fails. The list is a fixed shape, so both sides
# reduce.
law nth_from_end_pair_last:
  for x: Nat
  for y: Nat
  for d: Nat
  {S.nth_from_end(x <> y <> Nil{}, 0n, d) == y : Nat}

# LAW: the element of a two-element list that is `1n` positions from its end --
# the first one. This is the law that fixes the direction the distance counts
# in: `1n` reaches one element further back than `0n` does, and a body that
# counted from the front would answer `y` here.
law nth_from_end_pair_first:
  for x: Nat
  for y: Nat
  for d: Nat
  {S.nth_from_end(x <> y <> Nil{}, 1n, d) == x : Nat}

# LAW: the element of a three-element list that is `2n` positions from its end.
# The pair laws above are decided by a tail of one element and of two, and a body
# that got those right by a special case -- answering `d` unless the tail is
# short -- is separated here, because this list's tail is two elements long.
law nth_from_end_third:
  for x: Nat
  for y: Nat
  for z: Nat
  for d: Nat
  {S.nth_from_end(x <> y <> z <> Nil{}, 2n, d) == x : Nat}

# LAW: the last element of a list of `1n + n` elements, whatever they are. The
# list is `n` copies of `x` with a `y` at the end, so the run in front is of
# unknown length and the element the law names is the one at distance `0n`. The
# run is a variable, so this one is the induction, and it is the law that
# separates a body that answered an element from near the front from one that
# answered the end: the walk must carry the distance all the way to the `y`.
law nth_from_end_last:
  for n: Nat
  for x: Nat
  for y: Nat
  for d: Nat
  {S.nth_from_end(P.snoc(P.same(n, x), y), 0n, d) == y : Nat}

# LAW: one closed list, asked for a distance past its end. `[1n, 2n]` has two
# elements, at `0n` and `1n` positions from the end, so `2n` is out of range and
# the answer is the default `7n` -- not an element of the list, and not `0n`. The
# default is a literal here rather than a variable, so a body that ignored its
# third argument and answered a constant fails this law rather than satisfying it
# by accident.
law nth_from_end_out:
  {S.nth_from_end(1n <> 2n <> Nil{}, 2n, 7n) == 7n : Nat}
