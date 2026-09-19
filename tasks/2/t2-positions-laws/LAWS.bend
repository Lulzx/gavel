import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list holds no element, so the target occurs at no position in
# it. Both sides compute, so this is definitional, and it is a pin: it fixes the
# answer on the empty input, which none of the three laws below reaches -- they
# name their list as a cons cell or as `inc_all` of a variable -- and it is the
# only law here whose left-hand side is a closed list.
law positions_nil:
  for x: Nat
  {S.positions(x, Nil{}) == Nil{} : List<&2, Nat>}

# LAW: the step. A cons cell compares its head with the target and takes one of
# two answers: the head's own position `0n` in front of the tail's positions
# shifted along by one, or the shifted tail alone. Both sides compute, so this
# is definitional, and it is the law that says the *order* is the order the
# elements occur in -- the head's position is the smallest one and it is
# recorded at the front. It is stuck where the two compared values are the same
# variable -- `eq(k, k)` does not step -- which is what the law below is for.
law positions_step:
  for h: Nat
  for x: Nat
  for +t: List<&2, Nat>
  {S.positions(x, h <> t) == P.at_if(P.eq(h, x), 0n <> P.inc_all(S.positions(x, t)), P.inc_all(S.positions(x, t))) : List<&2, Nat>}

# LAW: an element equal to the target at the head is at position `0n`, and the
# rest of the answer is the tail's positions shifted along by one. This is the
# law that says a hit *contributes a position* rather than merely not being
# excluded, and it is the only law here that reads a hit: `positions_step` is
# stated for a variable `h` and a variable `x`, so on its own it never unfolds a
# comparison, and `positions_miss` is stated for a list in which nothing
# matches.
law positions_hit:
  for +k: Nat
  for +t: List<&2, Nat>
  {S.positions(k, k <> t) == 0n <> P.inc_all(S.positions(k, t)) : List<&2, Nat>}

# LAW: the not-found case. Nothing in `P.inc_all(xs)` is `0n`, so the target
# occurs at no position and the answer is the empty list -- which is the same
# answer as the empty input, so this law says the two are reached the same way
# and not merely that both are `Nil{}`. The list is a variable, so this one is
# the induction, and it is the law that pins the *value* of a miss: a body that
# recorded a position for every element, or that counted from `1n`, satisfies
# neither law above nor this one.
law positions_miss:
  for +xs: List<&2, Nat>
  {S.positions(0n, P.inc_all(xs)) == Nil{} : List<&2, Nat>}
