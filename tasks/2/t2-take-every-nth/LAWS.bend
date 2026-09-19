import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a stride of zero names no position, so nothing is kept. Both sides
# compute. The right-hand side calls no target, so this is an absolute anchor,
# and it is the only law that reaches `take_every_nth` with a count the match
# stops on.
#
# The convention is stated rather than derived: `0n` is not a stride at all, and
# the alternative -- keeping the head and then recursing on a stride that grows
# without bound -- has no answer at the end of the list. A body that read `0n` as
# "keep everything", the way a stride of `1n` does, is separated here and
# nowhere else.
law take_every_nth_zero:
  for xs: List<&2, Nat>
  {S.take_every_nth(0n, xs) == Nil{} : List<&2, Nat>}

# LAW: an empty list has nothing to keep, whatever the stride. Both sides
# compute and the right-hand side calls no target. The count is a variable, so
# the answer does not reduce on its own -- it is the induction on the count, and
# the stride step of it is the same answer reached through the walk.
law take_every_nth_nil:
  for n: Nat
  {S.take_every_nth(n, Nil{}) == Nil{} : List<&2, Nat>}

# LAW: a stride of one keeps every element, so the answer is the input. The
# right-hand side calls no target, so this is the other absolute anchor, and it
# is the law that says the walk starts at the *first* element: a body that kept
# positions `1n`, `1n + n`, ... instead -- one whole stride late -- answers the
# tail of `h <> t` where this one answers `h <> t`. Both sides compute once the
# walk's two laws have unfolded, so it is an induction on the list.
law take_every_nth_one:
  for +xs: List<&2, Nat>
  {S.take_every_nth(1n, xs) == xs : List<&2, Nat>}

# LAW: the hand-off from the answer to the walk. A positive stride is one plus
# the skip count, and the walk opens with nothing owed and the whole list. Both
# sides compute, so this is definitional, and it is the only law that reaches
# `every_nth_go` through `take_every_nth`: a body that opened the walk at the
# wrong skip count, or that never opened it, has a different unfolding here.
law take_every_nth_step:
  for +n: Nat
  for +xs: List<&2, Nat>
  {S.take_every_nth(1n + n, xs) == S.every_nth_go(xs, n, 0n) : List<&2, Nat>}

# LAW: the walk's answer when the list runs out. Both sides compute and the
# right-hand side calls no target. The list is a literal and the other two
# arguments are variables, so no other law here reaches this case.
law every_nth_go_nil:
  for m: Nat
  for i: Nat
  {S.every_nth_go(Nil{}, m, i) == Nil{} : List<&2, Nat>}

# LAW: the walk's keeping step. Nothing is owed, so the element in hand is kept
# and the next gap starts at `m`. Both sides compute, so this is definitional.
# The skip count is read twice here -- once as the count just exhausted and once
# as the count the next gap starts from -- which is what makes the reset
# visible: a body that started the next gap at `0n` keeps every element and is
# separated here.
law every_nth_go_take:
  for +m: Nat
  for +h: Nat
  for +t: List<&2, Nat>
  {S.every_nth_go(h <> t, m, 0n) == h <> S.every_nth_go(t, m, m) : List<&2, Nat>}

# LAW: the walk's skipping step. One skip is owed and is paid here: the element
# in hand is passed over and the count of what is still owed goes down by one.
# Both sides compute, so this is definitional. It is the law that separates a
# body which kept the element in hand from one which kept the right elements but
# dropped the wrong ones: the recursion is on the tail of the list matched, so a
# body that jumped a fixed distance instead of counting down has a different
# unfolding.
law every_nth_go_skip:
  for +m: Nat
  for h: Nat
  for +t: List<&2, Nat>
  for k: Nat
  {S.every_nth_go(h <> t, m, 1n + k) == S.every_nth_go(t, m, k) : List<&2, Nat>}

# LAW: one closed list, read end to end. `[1n, 2n, 3n, 4n, 5n]` at a stride of
# two keeps the elements at `0n`, `2n` and `4n`, so the answer is `[1n, 3n, 5n]`.
# A body that kept one element per stride but read the stride as the number of
# elements to keep, or that kept every element, satisfies several of the laws
# above and is separated here.
law take_every_nth_five:
  {S.take_every_nth(2n, 1n <> (2n <> (3n <> (4n <> (5n <> Nil{})))))
     == 1n <> (3n <> (5n <> Nil{})) : List<&2, Nat>}

# LAW: the same, at a stride that divides nothing and at a list that stops inside
# a gap. `[1n, 2n, 3n, 4n, 5n, 6n, 7n]` at a stride of three keeps `[1n, 4n,
# 7n]`: the run of skips after the last kept element does not have to complete
# before the list ends. A body that stopped one element early, or that padded the
# answer to a whole number of strides, is separated here.
law take_every_nth_seven:
  {S.take_every_nth(3n, 1n <> (2n <> (3n <> (4n <> (5n <> (6n <> (7n <> Nil{})))))))
     == 1n <> (4n <> (7n <> Nil{})) : List<&2, Nat>}
