import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: replacing in the empty list leaves it empty. Both sides compute, so this
# is definitional, and it is the anchor of the whole set: it is the one law whose
# right-hand side does not call `S.replace_first`, so a body that answered
# anything else for `Nil{}` -- or a body built as `c ++ ref(xs)` with a constant
# `c` that cancels out of every relative law -- is caught here and nowhere else.
law replace_first_nil:
  for k: Nat
  for y: Nat
  {S.replace_first(Nil{}, k, y) == Nil{} : List<&2, Nat>}

# LAW: the head is the first occurrence of itself, so replacing it puts `y` in
# front of the tail the walk was handed, untouched. The two sides are not
# convertible: the body steps to `P.rp_branch(P.eq(h, h), h, y, t, ...)`, and
# `P.eq` on two variables does not reduce, so that the decision is `True{}` is an
# induction on `h` and not an unfolding. It is what says the replacement is
# *first*: a body that replaced every occurrence would have `replace_first(t, h,
# y)` on the right here and fail.
law replace_first_hit:
  for h: Nat
  for t: List<&2, Nat>
  for y: Nat
  {S.replace_first(h <> t, h, y) == y <> t : List<&2, Nat>}

# LAW: a head that is not `k` survives, and the walk moves on. The premise is a
# property of the prelude's own `P.eq`, which the policy does not write, so it
# cannot be falsified by a submission and the law is not vacuous: it is a real
# case split on the decision. This is the law that leaves the *later* occurrences
# of `k` alone -- the head comes back and only the tail is walked.
law replace_first_miss:
  for a: Nat
  for b: Nat
  for t: List<&2, Nat>
  for y: Nat
  for e: {P.eq(a, b) == False{} : Bool}
  {S.replace_first(a <> t, b, y) == a <> S.replace_first(t, b, y) : List<&2, Nat>}

# LAW: the length does not change. This is an induction and not a computation:
# the step leaves the decision `P.eq(h, k)` in the way, so the case split the
# proof needs -- the step answers `y <> t` or `h <> r`, and either is one element
# in front of something whose length is the tail's -- is exactly what the
# induction hypothesis has to be told. It is what separates a replacement from a
# deletion or a duplication.
law replace_first_len:
  for +xs: List<&2, Nat>
  for +k: Nat
  for +y: Nat
  {P.len(S.replace_first(xs, k, y)) == P.len(xs) : Nat}

# LAW: the first occurrence is replaced and the second is not. This is the law
# the phrase *first* in the name means and no other law here says: both sides are
# closed, so they compute, and a body that carried on replacing after a hit
# answers `9n <> 2n <> 9n <> Nil{}` for the right-hand side and fails.
law replace_first_three:
  {S.replace_first(1n <> (2n <> (1n <> Nil{})), 1n, 9n)
     == 9n <> (2n <> (1n <> Nil{})) : List<&2, Nat>}

# LAW: a `k` that does not occur leaves the list alone. The other closed law
# takes the branch where the decision is `True{}` at the head; this one takes
# `False{}` at every cell and is the only one that observes what the walk returns
# when it reaches the end without a hit. A body that answered `y <> xs` whenever
# no occurrence was found agrees with every law above except this one.
law replace_first_absent:
  {S.replace_first(1n <> (2n <> (3n <> Nil{})), 5n, 9n)
     == 1n <> (2n <> (3n <> Nil{})) : List<&2, Nat>}
