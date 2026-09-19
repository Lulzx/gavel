import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there is nothing to raise in an empty suffix, so `max_all` answers
# `Nil{}`. Both sides compute, so this is definitional, and it is an absolute
# anchor: the right-hand side calls neither target. It is the only law that
# reaches `Nil{}` through `max_all` itself, so a body that answered anything else
# there is caught here.
law max_all_nil:
  for m: Nat
  {S.max_all(Nil{}, m) == Nil{} : List<&2, Nat>}

# LAW: the step of the raise. Each cell is replaced by the larger of itself and
# the number the suffix is raised by, and the walk continues with the same
# number. Both sides compute, so this is definitional. It is what pins *which*
# number each cell ends up carrying: a body folded with `Nat.min`, or one that
# dropped the cells the raise cannot change, is separated here.
law max_all_cons:
  for +h: Nat
  for t: List<&2, Nat>
  for m: Nat
  {S.max_all(h <> t, m) == Nat.max(h, m) <> S.max_all(t, m) : List<&2, Nat>}

# LAW: a list with no elements has no running maxima, so the answer is `Nil{}`.
# Both sides compute, and the right-hand side calls no target. A body that
# answered `1n` cells for nothing -- or one built as `ref(xs) + c` with a constant
# that cancels out of every law about a longer list -- is caught here.
law cum_max_nil:
  {S.cum_max(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: one element is the largest of everything up to and including itself, so
# the running maxima of a singleton is that element. Both sides compute, and the
# right-hand side calls no target. A body that read the answer as "everything a
# later element beats" and answered `Nil{}` there, or that started the run from
# `0n`, is separated here and nowhere above.
law cum_max_single:
  for x: Nat
  {S.cum_max(x <> Nil{}) == x <> Nil{} : List<&2, Nat>}

# LAW: the opening step, and the only law that pins the two targets together. The
# head is its own running maximum, and the rest of the answer is the running
# maxima of the *tail*, raised by the head -- the walk runs from the end of the
# list back to the front, so the suffix is computed first and the head is folded
# into it. Both sides compute, so this is definitional: a body that walked the
# other way, or that raised the suffix by the element behind the head, has a
# different unfolding and is separated here. The head is read twice -- on its own
# and as the raise -- so it is declared reusable.
law cum_max_cons:
  for +h: Nat
  for t: List<&2, Nat>
  {S.cum_max(h <> t) == h <> S.max_all(S.cum_max(t), h) : List<&2, Nat>}

# LAW: the running maxima of a list is as long as the list, and the raise does not
# change that either. This is the induction: `cum_max` on a variable list is
# stuck, and the step needs `S.max_all` to hand back a list of the same length,
# which is a second induction on the suffix. It is an absolute anchor -- the
# right-hand side calls neither target -- so every body has to answer with a list
# of the right *length* before any law about its cells can be believed: a body
# that dropped a cell, or that answered the distinct maxima instead of one per
# element, is separated here.
law cum_max_len:
  for xs: List<&2, Nat>
  {P.len(S.cum_max(xs)) == P.len(xs) : Nat}

# LAW: one closed list, read end to end. The answer to `[3n, 1n, 2n]` is
# `[3n, 3n, 3n]`: the third cell carries the `3n` from the first, and the `1n` in
# the middle raises nothing. A body that answered the list itself, the running
# minima, or the maxima of the suffixes -- which agrees on every list that only
# ever rises -- satisfies every law above and is separated here.
law cum_max_three:
  {S.cum_max(3n <> (1n <> (2n <> Nil{}))) == 3n <> (3n <> (3n <> Nil{})) : List<&2, Nat>}
