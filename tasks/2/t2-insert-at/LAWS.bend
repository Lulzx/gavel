import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: at position zero the element goes in front of the whole list. The
# left-hand side is ground in the count -- the match steps on `0n` and answers
# `y <> xs` without looking at the list -- so no step law below reaches this
# answer, and a body whose `0n` case dropped `y` would be caught only here.
law insert_at_zero:
  for xs: List<Nat>
  for y: Nat
  {S.insert_at(0n, xs, y) == y <> xs : List<Nat>}

# LAW: a count past the end of the list puts the element on the end. The
# left-hand side is ground in the list: the match steps on the successor count
# and then finds `Nil{}` where it wanted an element to stand in front of. The
# cons law below names its list as `h <> t`, so neither it nor `insert_at_zero`
# covers this answer -- a body that returned `Nil{}` here, dropping `y`
# entirely, satisfies both of them.
law insert_at_nil:
  for n: Nat
  for y: Nat
  {S.insert_at(1n+n, Nil{}, y) == y <> Nil{} : List<Nat>}

# LAW: one step into the list keeps the head it passed and recurses on the
# tail. Both sides compute, so this is the definition written out, and it is
# what makes the count mean a position: a body that recursed on the same list,
# or that put `y` in front of the head instead of behind it, leaves the two
# sides unequal.
law insert_at_cons:
  for n: Nat
  for h: Nat
  for t: List<Nat>
  for y: Nat
  {S.insert_at(1n+n, h <> t, y) == h <> S.insert_at(n, t, y) : List<Nat>}

# LAW: inserting at `n` is the first `n` elements, then the new element, then
# everything the list had left. This is the law with content, and it is
# inductive in the count: `take` and `drop` match on their first argument, so
# with a variable count the right-hand side does not reduce on its own. It is
# the law that ties the answer to the *position* rather than to the recursion:
# a body that ignored `n` and consed `y` onto the front -- or onto the end --
# satisfies every law above and fails this one.
law insert_at_take_drop:
  for n: Nat
  for xs: List<Nat>
  for y: Nat
  {S.insert_at(n, xs, y) == P.append(P.take(n, xs), y <> P.drop(n, xs)) : List<Nat>}
