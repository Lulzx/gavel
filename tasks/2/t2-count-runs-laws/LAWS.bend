import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no runs at all. Both sides compute, so this one is
# definitional, and it is the anchor: no other law here names the empty input,
# and a body that answered anything but `0n` there is caught only by this one.
law count_runs_nil:
  {S.count_runs(Nil{}) == 0n : Nat}

# LAW: a one-element list is one run, and it is the run of that element. Both
# sides compute, so this is definitional too, and it is the half of the anchor
# the empty list does not cover: the step law below names `a <> (b <> t)`, so a
# body that answered `0n` -- or two runs -- for a lone element satisfies both
# laws about longer lists and this one separates it.
law count_runs_single:
  for x: Nat
  {S.count_runs(x <> Nil{}) == 1n : Nat}

# LAW: two equal neighbours are the same run, so they add nothing to the count
# of the list that starts at the second one. The two sides are not convertible:
# the step leaves `P.nsub(1n, P.is_eq(a, a))` in the way, and `P.is_eq` on two
# variables does not reduce, so this law is an induction and not a computation.
# It is what says the answer does not grow at a continuation.
law count_runs_same:
  for a: Nat
  for t: List<&2, Nat>
  {S.count_runs(a <> (a <> t)) == S.count_runs(a <> t) : Nat}

# LAW: two neighbours that differ start a new run, and it is worth exactly one.
# This is what says the answer grows at a boundary, and how much: a body that
# added `P.is_eq(a, b)` instead of `P.nsub(1n, P.is_eq(a, b))` -- a run worth one
# at a continuation and nothing at a boundary -- agrees with every law above and
# is separated here. The premise is a property of the prelude's own `P.is_eq`,
# which the policy does not write, so the hypothesis cannot be falsified by a
# body: it is a real case split rather than a vacuous law.
law count_runs_diff:
  for a: Nat
  for b: Nat
  for t: List<&2, Nat>
  for e: {P.is_eq(a, b) == 0n : Nat}
  {S.count_runs(a <> (b <> t)) == 1n + S.count_runs(b <> t) : Nat}
