import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `indexed` is the counting helper started at zero. Both sides compute --
# `indexed` is asked for nothing more than that call -- so this is definitional,
# and it is the law that ties the two targets together: a body that wrote
# `indexed` out by hand, or that started the count anywhere but `0n`, is caught
# here and nowhere else, because every other law is stated over the helper.
law indexed_zero:
  for xs: List<&2, Nat>
  {S.indexed(xs) == S.indexed_go(xs, 0n) : List<&2, P.Indexed>}

# LAW: the step. The head is paired with the position it is at, and the tail is
# numbered from the next position on. Both sides compute, so this is
# definitional, and it is the law that says which number goes with which
# element: a body that paired the head with the *tail's* position, or that
# recursed on `t` without stepping the count, leaves the two sides unconvertible.
# The list is named as `x <> t` rather than left as a variable, because there is
# no head to pair with a position otherwise.
law indexed_cons:
  for x: Nat
  for t: List<&2, Nat>
  for i: Nat
  {S.indexed_go(x <> t, i) == P.MkIndexed{i, x} <> S.indexed_go(t, i + 1n) : List<&2, P.Indexed>}

# LAW: the count half, and the first of the two laws here that is not
# definitional: the list is a variable, so the helper cannot take a step and the
# two sides do not compute. The induction on the list is the proof, and it is
# the law that reads the answer as a number of pairs -- the positions run out
# exactly when the elements do, however the elements themselves came out.
law indexed_len:
  for xs: List<&2, Nat>
  for i: Nat
  {P.plen(S.indexed_go(xs, i)) == P.len(xs) : Nat}

# LAW: the content half, and the second law that is not definitional. Throwing
# the positions away gives the input back in the order it came in. The two laws
# read the same answer two ways: a body that kept the right number of pairs but
# filled them with the wrong elements -- reading the same element twice, or
# writing one element's successor in its place -- satisfies the count law and is
# caught here.
law indexed_elems:
  for xs: List<&2, Nat>
  for i: Nat
  {P.elems(S.indexed_go(xs, i)) == xs : List<&2, Nat>}
