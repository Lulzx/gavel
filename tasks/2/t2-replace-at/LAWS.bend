import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a count past the end of the empty list has no position to replace, so the
# answer is the empty list. Both sides compute, so this is definitional, and it
# is the absolute anchor of `replace_at`: the right-hand side mentions no target
# at all, and it is the only law whose left-hand side is an empty list.
law replace_at_nil:
  for n: Nat
  for y: Nat
  {S.replace_at(n, Nil{}, y) == Nil{} : List<Nat>}

# LAW: at position `0n` the head is dropped and `y` takes its place. The
# count is the literal `0n`, so the match inside `replace_at` steps and answers
# without recursing -- the successor law below is stated at `1n + n` and never
# reaches this answer. Both sides compute, so this is definitional, and it is
# the law that says the new element *replaces* rather than joins: a body whose
# `0n` case answered `y <> xs` leaves the two sides unequal here.
law replace_at_zero:
  for h: Nat
  for t: List<Nat>
  for y: Nat
  {S.replace_at(0n, h <> t, y) == y <> t : List<Nat>}

# LAW: one step into the list keeps the head it passed and recurses on the
# element behind it. Both sides compute, so this is the definition written out,
# and it is what makes the count mean a position: a body that recursed on the
# whole list, or that dropped the head instead of keeping it, leaves the two
# sides unequal.
law replace_at_succ:
  for n: Nat
  for h: Nat
  for t: List<Nat>
  for y: Nat
  {S.replace_at(1n + n, h <> t, y) == h <> S.replace_at(n, t, y) : List<Nat>}

# LAW: replacing the element at position `n` twice is replacing it once, with
# the second value. This is the law with content, and it is inductive in the
# count: it is the one law here that fixes *which* position the count picks, not
# merely that a position is walked, because a body that replaced the element
# after the one asked for -- or that numbered positions from one -- moves the
# value it writes on the first application and the second does not find it.
law replace_at_idem:
  for n: Nat
  for xs: List<Nat>
  for y: Nat
  for z: Nat
  {S.replace_at(n, S.replace_at(n, xs, y), z) == S.replace_at(n, xs, z) : List<Nat>}
