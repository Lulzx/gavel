import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list is a palindrome. Both sides compute, so this one is
# definitional, and the constant `False{}` body fails it.
law is_pal_nil:
  {S.is_pal(Nil{}) == True{} : Bool}

# LAW: a one-element list is a palindrome. Both sides compute only once the two
# equal elements are compared, which is why the reflexivity of `P.eq_nat` is a
# helper rather than a computation -- but it is a pin all the same, and it is
# what the constant `False{}` body fails.
law is_pal_single:
  for h: Nat
  {S.is_pal(h <> Nil{}) == True{} : Bool}

# LAW: a two-element list of distinct elements is not a palindrome. A concrete
# instance, and it is the law that rules the *constant* answer out: a body that
# answers `True{}` everywhere, or that compares the list with itself instead of
# with its reverse, satisfies both pins above and leaves this one unprovable.
law is_pal_two_distinct:
  {S.is_pal(0n <> 1n <> Nil{}) == False{} : Bool}

# LAW: reversing a list does not change whether it is a palindrome. This is the
# work, and nothing about it is definitional: `P.rev` of a variable list is
# stuck, so the goal is about `P.rev(xs)` twice over, once under the other. The
# policy needs `P.rev(P.rev(xs)) == xs` -- which is a law in another task and so
# must be reproved here -- and the symmetry of `P.eq_list`, which is an
# induction of its own because `P.eq_list` reads its two sides left to right.
law is_pal_rev:
  for +xs: List<&2, Nat>
  {S.is_pal(P.rev(xs)) == S.is_pal(xs) : Bool}
