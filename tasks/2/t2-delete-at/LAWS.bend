import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: dropping the element at position `0n` keeps the tail and nothing else.
# The left-hand side is ground in its count and its list both: `delete_at`
# steps on `0n`, then on the cons cell, and answers the tail outright. It is
# the law that rules out a body whose `0n` case answered the whole list, which
# the successor law cannot see -- that one names its count as `1n + n`.
law delete_at_zero:
  for h: Nat
  for t: List<Nat>
  {S.delete_at(0n, h <> t) == t : List<Nat>}

# LAW: a count past the end of the list has nothing to drop, so it answers
# `Nil{}`. The left-hand side is ground in its list. It is not definitional:
# with a variable `n` the match inside `delete_at` has nothing to step on, so
# this one is itself an induction in `n`, and it is the only law here that
# says what happens when the count and the list run out together.
law delete_at_nil:
  for n: Nat
  {S.delete_at(n, Nil{}) == Nil{} : List<Nat>}

# LAW: at a successor count the head survives and the element is dropped from
# the tail. Both sides compute, so this is the definition written out, and it
# is the law that says the answer is *built out of* the head: a body that
# recursed on the wrong list, or that dropped the head instead of keeping it,
# leaves the two sides unequal. On its own it says nothing about where the
# recursion stops, which is why the two laws above are not optional.
law delete_at_succ:
  for n: Nat
  for h: Nat
  for t: List<Nat>
  {S.delete_at(1n+n, h <> t) == h <> S.delete_at(n, t) : List<Nat>}

# LAW: dropping the element at position `n` is keeping the `n` elements in
# front of it and the elements behind it -- the second `drop` steps one more
# element off the list the first one left. This is the law with content, and it
# is inductive in `n`: a body that ignored its count, or that dropped the
# element *after* the one asked for, keeps the two sides apart at every length
# the count and the list both reach.
law delete_at_take_drop:
  for n: Nat
  for xs: List<Nat>
  {S.delete_at(n, xs) == P.append(P.take(n, xs), P.drop(1n, P.drop(n, xs))) : List<Nat>}
