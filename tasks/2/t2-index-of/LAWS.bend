import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no positions and no element to compare with, so the
# answer is the sentinel -- which at the empty list is `0n`, since that is its
# length. Both sides compute, so this is definitional, and it is a pin: it fixes
# the answer on the empty input, which the step law below never reaches, and it
# is the only law here whose left-hand side is a closed list.
law index_of_nil:
  for k: Nat
  {S.index_of(Nil{}, k) == 0n : Nat}

# LAW: the step. A cons cell compares its head with the target and takes one of
# two answers: `0n` if they are equal, and otherwise one more than the position
# of the target in the tail. Both sides compute, so this is definitional, and it
# is the law that says the answer counts *positions*: the recursion steps by
# exactly one, and the head is the one compared. `P.eq` and `P.at_if` are the
# prelude's comparison and decision; the law is stated in terms of them because
# the two answers are a decision the body takes rather than a value it unfolds.
law index_of_step:
  for h: Nat
  for k: Nat
  for t: List<Nat>
  {S.index_of(h <> t, k) == P.at_if(P.eq(h, k), 0n, 1n + S.index_of(t, k)) : Nat}

# LAW: an element that is at the head is at position `0n`, whatever the rest of
# the list is. The step law above is stated for a variable `k`, so on its own it
# never unfolds a comparison: `eq(k, k)` is stuck where the two arguments are
# the same variable, and this law is the one that says the comparison decides
# `True{}` there. `index_of_step` reads the answer at a cons cell and
# `index_of_nil` at the empty list, and neither one looks at a hit.
law index_of_hit:
  for k: Nat
  for t: List<Nat>
  {S.index_of(k <> t, k) == 0n : Nat}

# LAW: the not-found case, which is what the sentinel is *for*. Searching a list
# in which nothing is `0n` finds nothing, so the answer is the length: one past
# the last position, and the same value the list's length is. The list is a
# variable, so this one is the induction, and it is the law that fixes the
# sentinel's value -- `index_of_step` leaves the answer at the empty list free,
# and a body that answered any constant there satisfies neither law above nor
# this one.
law index_of_miss:
  for xs: List<Nat>
  {S.index_of(P.inc_all(xs), 0n) == P.len(xs) : Nat}
