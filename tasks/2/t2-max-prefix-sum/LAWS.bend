import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has one prefix, the empty one, and it sums to `0n`. Both
# sides compute, so this is definitional, and it is the absolute anchor: the
# right-hand side mentions no target at all. It is also the only law that
# reaches the empty input -- the walk's own empty case is a law below -- so
# without it a body that answered a constant would keep every other law here.
law max_prefix_sum_nil:
  {S.max_prefix_sum(Nil{}) == 0n : Nat}

# LAW: the answer is the walk started at zero, with nothing accumulated and the
# empty prefix already standing as the best. It is the law that says
# `max_prefix_sum` is the walk, and not merely something the walk agrees with at
# one input: a body that seeded the walk with a non-zero best answers `1n` here,
# and a body that computed the prefix sums by some other route answers a
# different term at every list. The list is a variable, so neither side reduces
# on its own.
law max_prefix_sum_walk:
  for +xs: List<&2, Nat>
  {S.max_prefix_sum(xs) == S.max_prefix_sum_go(xs, 0n, 0n) : Nat}

# LAW: the walk's empty case is its best running value. Definitional, and it is
# the pin on *which* of the two running values is the answer: a body that
# answered the running sum here keeps the step law below and loses this one.
law mpg_nil:
  for acc: Nat
  for best: Nat
  {S.max_prefix_sum_go(Nil{}, acc, best) == best : Nat}

# LAW: the walk's step adds the head to the running sum and keeps whichever of
# that new sum and the best so far is larger, then recurses on the tail. Both
# sides compute, so this is definitional, and it is the law with the content: a
# body that carried the head into the sum but not into the best -- lagging one
# prefix behind -- is separated here, and so is a body that took the largest
# *element* seen for the best rather than the largest *prefix sum*. The running
# values are universally quantified, so the law holds at every pair the walk can
# be started from, not only at the pair `max_prefix_sum` starts it with.
law mpg_cons:
  for +h: Nat
  for t: List<&2, Nat>
  for +acc: Nat
  for best: Nat
  {S.max_prefix_sum_go(h <> t, acc, best) == S.max_prefix_sum_go(t, Nat.add(acc, h), P.max2(Nat.add(acc, h), best)) : Nat}

# LAW: one closed list, answered end to end. The laws above fix the walk at
# every shape of argument; this one fixes what it comes to on `[3n, 1n, 2n]`,
# whose prefixes sum to `0n`, `3n`, `4n` and `6n`, so the largest is `6n` -- the
# whole list, and neither the largest element `3n` nor the number of elements.
law max_prefix_sum_three:
  {S.max_prefix_sum(3n <> 1n <> 2n <> Nil{}) == 6n : Nat}
