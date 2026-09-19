import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list partitions into two empty lists. Both sides compute, so
# this one is definitional, and it is the weak half: it fixes the pair where
# there is nothing to sort into it and leaves every other input to the laws
# below.
law partition_below_nil:
  for n: Nat
  {S.partition_below(Nil{}, n) == P.MkL{Nil{}, Nil{}} : P.PairL}

# LAW: a head at most the threshold joins the *front* and the back is the back
# of the tail's pair. The premise is the predicate's own answer and it is what
# makes the law say anything: with `h` and `n` variables `P.le(h, n)` is stuck,
# so neither side reduces without it. A body that sent every element to the back
# leaves the two sides here unconvertible, because the head is on the back of
# its right-hand side and on the front of its left.
law partition_below_keep:
  for +h: Nat
  for +t: List<&2, Nat>
  for +n: Nat
  for e: {P.le(h, n) == True{} : Bool}
  {S.partition_below(h <> t, n) == P.MkL{h <> P.front(S.partition_below(t, n)), P.back(S.partition_below(t, n))} : P.PairL}

# LAW: a head above the threshold joins the *back* and the front is the front of
# the tail's pair. This is the half `t3-filter-bound` cannot state, since there
# the rejected element is gone: here it has to be *somewhere*, and the law says
# where. It is also the only law that pins the rejecting branch, and it is not
# implied by `keep` -- the pair a body produces on the two branches differs, and
# a body that put every element in the front satisfies the shape of `keep` and
# contradicts this one, because the head is on the back of its right-hand side
# and on the front of its left.
law partition_below_drop:
  for +y: Nat
  for +t: List<&2, Nat>
  for +n: Nat
  for e: {P.le(y, n) == False{} : Bool}
  {S.partition_below(y <> t, n) == P.MkL{P.front(S.partition_below(t, n)), y <> P.back(S.partition_below(t, n))} : P.PairL}

# LAW: the two halves have between them as many elements as the input. This is
# the work, and neither cons law above implies it: they say which half each head
# joins, and this says none is lost and none is counted twice, which no
# unfolding of a variable list can show. Nothing reduces on its own --
# `S.partition_below` of a variable list is stuck, so the induction hypothesis is
# the only thing that can rewrite the goal -- and the step needs `P.len` of the
# pair the cons step produced, which is a fact about `P.part_put` that the
# prelude does not state.
law partition_below_len:
  for +xs: List<&2, Nat>
  for +n: Nat
  {P.len(P.front(S.partition_below(xs, n))) + P.len(P.back(S.partition_below(xs, n))) == P.len(xs) : Nat}
