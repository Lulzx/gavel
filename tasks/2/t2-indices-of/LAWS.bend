import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no positions at all, so the answer is the empty list,
# whatever is being searched for. Both sides compute, so this is definitional,
# and it is a pin: it fixes the answer on the empty input, which the step law
# below never reaches, and it is the only law here whose left-hand side is a
# closed list.
law indices_of_nil:
  for k: Nat
  {S.indices_of(Nil{}, k) == Nil{} : List<Nat>}

# LAW: the step. A cons cell compares its head with the target and takes one of
# two answers: the position `0n` consed onto the rest when they are equal, and
# the rest on its own when they are not. Either way the rest is *shifted* -- one
# step for every element the head stands in front of -- so the positions come
# out ascending from the front of the list. Both sides compute, so this is
# definitional, and it is the law that says the answer counts positions: the
# head is the element compared, and every answer behind it is one further along.
# `P.eq` and `P.cons_if` are the prelude's comparison and decision; the law is
# stated in terms of them because the two answers are a decision the body takes
# rather than a value it unfolds.
law indices_of_step:
  for h: Nat
  for k: Nat
  for t: List<Nat>
  {S.indices_of(h <> t, k) == P.cons_if(P.eq(h, k), 0n, P.inc_all(S.indices_of(t, k))) : List<Nat>}

# LAW: an element at the head is at position `0n`, and every hit in the tail is
# one position further along, so the answer is `0n` consed onto the shifted
# tail. The step law above is stated for a variable `k`, so on its own it never
# unfolds a comparison: `eq(k, k)` is stuck where the two arguments are the same
# variable, and this law is the one that says the comparison decides `True{}`
# there. It is also the law that fixes the *shape* of a hit -- `0n` first, and
# the rest of the answer shifted up by one.
law indices_of_hit:
  for k: Nat
  for t: List<Nat>
  {S.indices_of(k <> t, k) == 0n <> P.inc_all(S.indices_of(t, k)) : List<Nat>}

# LAW: searching a list in which nothing is `0n` finds nothing, so the answer is
# the empty list. The list is a variable, so this one is the induction, and it
# is the law that fixes what a *miss* contributes: no position, and no shift
# that a position could be read out of either. `indices_of_step` leaves the
# answer at the empty list free and `indices_of_hit` leaves the miss arm of the
# decision free; a body that answered any position at a miss, or that answered a
# constant of the wrong shape at the empty list, satisfies neither of the laws
# above nor this one.
law indices_of_miss:
  for xs: List<Nat>
  {S.indices_of(P.inc_all(xs), 0n) == Nil{} : List<Nat>}
