import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no runs, so the answer is the empty list. Both sides
# compute, and the right-hand side calls no target -- this is the absolute
# anchor. It is also the only law that reaches the empty input through
# `run_lengths` itself, so a body that answered one cell for nothing, or that
# answered whatever list it was handed, is caught here and nowhere else.
law run_lengths_nil:
  {S.run_lengths(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: one element is one run of one element, whatever it is, so the answer is a
# single cell holding `1n`. Both sides compute and the right-hand side calls no
# target. It is the law that separates the two bodies every other law here is
# blind to: one that emits a cell per element without merging the equal ones,
# and one that reads the answer as the lengths of the runs *after* the first.
law run_lengths_single:
  for x: Nat
  {S.run_lengths(x <> Nil{}) == 1n <> Nil{} : List<&2, Nat>}

# LAW: the hand-off from the answer to the walk. A list of two or more elements
# opens its first run at `1n` and hands the second element and the rest to the
# walk with the comparison of the two heads already decided -- both are in hand
# here, so nothing is left for the walk to compare. Both sides compute, so this
# is definitional, and it is the only law that reaches the walk through
# `run_lengths`: a body that answered the runs without walking the tail, or that
# started the first run at `0n`, is separated here.
law run_lengths_step:
  for +h: Nat
  for +h2: Nat
  for +t2: List<&2, Nat>
  {S.run_lengths(h <> (h2 <> t2)) == S.run_lengths_go(t2, P.same(h, h2), 1n, h2) : List<&2, Nat>}

# LAW: the walk's answer at the empty tail when the element in hand continues the
# run. The element is counted into the run -- the run was `cur` long up to the
# element before it, and the element makes it `1n + cur`. Both sides compute and
# the right-hand side calls no target. The length carried is universally
# quantified, so the law is read at every run length: a body that emitted the run
# without the element in hand, or that emitted `cur` where the element is part of
# the run, is separated here and nowhere else.
law run_lengths_go_last_in_run:
  for cur: Nat
  for h: Nat
  {S.run_lengths_go(Nil{}, True{}, cur, h) == (1n + cur) <> Nil{} : List<&2, Nat>}

# LAW: the walk's other answer at the empty tail: the element in hand does not
# continue the run, so the run carried so far is emitted first and the element
# after it, as a run of one. Both sides compute and the right-hand side calls no
# target. A body that dropped the carried run -- answering one cell where the
# list ends -- or that merged the last element into the run before it without
# asking, is separated here.
law run_lengths_go_last_alone:
  for cur: Nat
  for h: Nat
  {S.run_lengths_go(Nil{}, False{}, cur, h) == cur <> (1n <> Nil{}) : List<&2, Nat>}

# LAW: the walk's growing step. The element in hand is in the run, the run's
# length grows by one, and the comparison of the next element with this one --
# both in hand, since the nested match has already exposed the next -- is decided
# here and handed to the recursion. Both sides compute, so this is definitional:
# a body that forgot to grow the run, or that decided the next comparison
# between the wrong pair of elements, has a different unfolding here.
law run_lengths_go_grow:
  for +cur: Nat
  for +h: Nat
  for +h2: Nat
  for +t2: List<&2, Nat>
  {S.run_lengths_go(h2 <> t2, True{}, cur, h) == S.run_lengths_go(t2, P.same(h, h2), 1n + cur, h2) : List<&2, Nat>}

# LAW: the walk's starting step. The element in hand does not continue the run,
# so the run carried so far is emitted, a new run of one element begins with the
# element in hand, and the next comparison is decided here as above. Both sides
# compute. The emitted `cur` is what ties a run's end to its start: a body that
# emitted one cell per element, or that dropped the carried run, is separated
# here and nowhere above.
law run_lengths_go_fresh:
  for +cur: Nat
  for +h: Nat
  for +h2: Nat
  for +t2: List<&2, Nat>
  {S.run_lengths_go(h2 <> t2, False{}, cur, h) == cur <> S.run_lengths_go(t2, P.same(h, h2), 1n, h2) : List<&2, Nat>}

# LAW: two equal neighbours are one run. The step onto an element equal to the
# one in hand grows the run and carries the comparison of the element after it,
# which is what continuing into the tail with `True{}` does. This is the law with
# content: `P.same(a, a)` steps a successor off each side at a time, so at a
# variable `a` it does not reduce, and the two sides are not the same unfolding.
# That a number is the same as itself is an induction, and only it collapses the
# comparison the walk is carrying. A body that treated every element as its own
# run, or that compared the wrong pair, leaves this law unconvertible.
law run_lengths_go_same:
  for +cur: Nat
  for +a: Nat
  for +t: List<&2, Nat>
  {S.run_lengths_go(a <> t, True{}, cur, a) == S.run_lengths_go(t, True{}, 1n + cur, a) : List<&2, Nat>}

# LAW: one closed list, read end to end. `[1n, 1n, 2n]` is a run of two and a run
# of one, so the answer is `[2n, 1n]`: the equal neighbours at the front are one
# run, and the `2n` starts a run of its own. A body that emitted a cell per
# element, or that merged the last element into the run before it without
# asking, satisfies several of the laws above and is separated here.
law run_lengths_three:
  {S.run_lengths(1n <> (1n <> (2n <> Nil{}))) == 2n <> (1n <> Nil{}) : List<&2, Nat>}
