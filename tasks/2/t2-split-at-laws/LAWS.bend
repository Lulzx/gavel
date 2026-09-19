import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a count of `0n` takes nothing. Both sides compute, so this one is
# definitional, and it is the pin on the base case of the count: the step laws
# below name a successor count only, so a body that took an element at `0n` is
# caught here and nowhere else.
law split_at_zero:
  for xs: List<&2, Nat>
  {S.split_at(0n, xs) == P.MkDuo{Nil{}, xs} : P.Duo}

# LAW: there is nothing to take from an empty list, whatever the count. Both
# sides compute -- the count is a variable, so this is an induction rather than
# an unfolding -- and it is the pin on the empty-list case, which
# `split_at_zero` does not reach and which the step laws, naming a cons cell,
# do not either: a body that answered a non-empty first half there escapes them.
law split_at_nil:
  for n: Nat
  {S.split_at(n, Nil{}) == P.MkDuo{Nil{}, Nil{}} : P.Duo}

# LAW: the step, first half. A successor count over a non-empty list takes the
# head into the first half, in front of the first half of the tail's pair. Both
# sides compute, so this is definitional, and it is the law that says the head
# goes into the *first* half: a body that sent it to the second one leaves the
# two sides unconvertible.
law split_at_cons_left:
  for n: Nat
  for x: Nat
  for xs: List<&2, Nat>
  {P.left_half(S.split_at(1n + n, x <> xs)) == x <> P.left_half(S.split_at(n, xs)) : List<&2, Nat>}

# LAW: the step, second half. The same input answers a second half that is
# exactly the second half of the tail's pair. Both sides compute, so this is
# definitional, and it is the law that says the second half does not grow: a
# body that duplicated the head into both halves, or that left it in the second
# half, satisfies the first-half law and contradicts this one.
law split_at_cons_right:
  for n: Nat
  for x: Nat
  for xs: List<&2, Nat>
  {P.right_half(S.split_at(1n + n, x <> xs)) == P.right_half(S.split_at(n, xs)) : List<&2, Nat>}

# LAW: the two halves put back together are the list that was split. Neither
# side computes on a variable count -- `split_at` is stuck until its count is a
# successor -- so this one is inductive, and it is the law that says no element
# is lost and none is counted twice. The two halves' laws above name one point
# each and cannot say it: a body that took one element too few satisfies the
# first-half law (the head still joins the front) and disagrees here, where the
# element that was dropped has to come back.
law split_at_decomp:
  for n: Nat
  for xs: List<&2, Nat>
  {P.append(P.left_half(S.split_at(n, xs)), P.right_half(S.split_at(n, xs))) == xs : List<&2, Nat>}
