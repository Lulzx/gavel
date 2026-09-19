import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no element to compare with `x`, so nothing is removed.
# Both sides compute, so this is definitional, and it is a pin: it fixes the
# answer on the empty input, which none of the three laws below reaches -- they
# name their list as a cons cell or as `inc_all` of a variable -- and it is the
# only law here whose left-hand side is a closed list.
law delete_nil:
  for x: Nat
  {S.delete(x, Nil{}) == Nil{} : List<&2, Nat>}

# LAW: the step. A cons cell compares its head with the target and takes one of
# two answers: the tail, which drops the head, or the head in front of the
# removal from the tail. Both sides compute, so this is definitional, and it is
# the law that says the answer is *built out of* the head -- a body that
# recursed on the wrong list, or that kept a head it had just compared, leaves
# the two sides unconvertible. `P.eq` and `P.at_if` are the prelude's comparison
# and decision; the law is stated in terms of them because the two answers are a
# decision the body takes rather than a value it unfolds. It is stuck where the
# two compared values are the same variable -- `eq(k, k)` does not step -- which
# is what the law below is for.
law delete_step:
  for h: Nat
  for x: Nat
  for +t: List<&2, Nat>
  {S.delete(x, h <> t) == P.at_if(P.eq(h, x), t, h <> S.delete(x, t)) : List<&2, Nat>}

# LAW: an element equal to the target at the head is removed, and the tail
# survives as it stands -- not with anything further taken out of it, even when
# the tail carries the target again. This is the law that says *first*
# occurrence and not every one, and it is the only law here that reads a hit:
# `delete_step` is stated for a variable `h` and a variable `x`, so on its own
# it never unfolds a comparison, and `delete_miss` is stated for a list in which
# nothing matches.
law delete_hit:
  for +k: Nat
  for +t: List<&2, Nat>
  {S.delete(k, k <> t) == t : List<&2, Nat>}

# LAW: the not-found case. Nothing in `P.inc_all(xs)` is `0n`, so the removal
# has nothing to do and the whole list comes back in the order it was in. The
# list is a variable, so this one is the induction, and it is the law that pins
# the *value* of a miss: `delete_step` leaves the answer at a miss free, and a
# body that dropped its head on a miss, or that reordered the list as it walked,
# satisfies neither law above nor this one.
law delete_miss:
  for +xs: List<&2, Nat>
  {S.delete(0n, P.inc_all(xs)) == P.inc_all(xs) : List<&2, Nat>}
