import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no second largest element, and the answer says so with
# `0n`. Both sides compute, so this is definitional, and it is the absolute
# anchor of `second_max`: the right-hand side mentions no target at all. It is
# the only law that reaches the empty input -- the cons law below names a list
# with at least one element -- so without it a body that answered a constant
# would keep every other law here.
law second_max_nil:
  {S.second_max(Nil{}) == 0n : Nat}

# LAW: a cons cell hands its tail to the walk, with the head as the largest seen
# so far and `0n` as the second. Definitional, and it is the law that says
# `second_max` is the walk started at the head rather than at a constant or at
# the last element: a body that seeded the walk with `0n` twice answers `0n`
# here on a one-element list and keeps every other law.
law second_max_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.second_max(h <> t) == S.sec_go(t, h, 0n) : Nat}

# LAW: the walk's empty case is its second running value. Definitional, and it
# is the pin on the walk: with the step law below it fixes which of the two
# running values is the answer, so a body that answered `top` here keeps the
# step law and loses this one.
law sec_go_nil:
  for top: Nat
  for second: Nat
  {S.sec_go(Nil{}, top, second) == second : Nat}

# LAW: the walk's step folds the head into both running values and recurses on
# the tail. Definitional, and it is the law with the content: the new largest is
# `P.max2(h, top)` and the new second is `P.max2(P.min2(h, top), second)`, so a
# body that folded the head through one comparison only -- the larger into both
# slots, say -- is separated here while keeping the two laws above, and a body
# that dropped the head entirely answers the starting pair's answer and is
# separated here too. The running values are universally quantified, so the law
# holds at every pair the walk can be started from, not only at the one
# `second_max` starts it with.
law sec_go_cons:
  for +h: Nat
  for t: List<&2, Nat>
  for +top: Nat
  for second: Nat
  {S.sec_go(h <> t, top, second) == S.sec_go(t, P.max2(h, top), P.max2(P.min2(h, top), second)) : Nat}

# LAW: one closed list, answered end to end. The laws above fix the walk at
# every shape of argument; this one fixes what the walk comes to on
# `[3n, 1n, 2n]`, whose second largest element is `2n` -- not the largest, `3n`,
# and not the smallest, `1n`.
law second_max_three:
  {S.second_max(3n <> 1n <> 2n <> Nil{}) == 2n : Nat}
