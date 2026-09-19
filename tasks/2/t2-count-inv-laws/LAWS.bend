import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has nothing to be out of order with, so it has no
# inversions. Both sides compute, so this one is definitional, and it is the
# anchor: no other law here names the empty input, and the step law below names
# its argument as a cons cell, so a body that answered anything but `0n` there
# is caught only by this one.
law count_inv_nil:
  {S.count_inv(Nil{}) == 0n : Nat}

# LAW: a one-element list has no pair of positions at all, so it has no
# inversions either. It is the other half of the anchor: the smallest input the
# step law can build is a cons cell with a variable tail, so the singleton is
# where the step's answer first has to agree with the empty case's. Both sides
# compute, so this one is definitional too, and any body that answers the empty
# list wrongly fails it (the singleton reaches that same branch).
law count_inv_single:
  for x: Nat
  {S.count_inv(x <> Nil{}) == 0n : Nat}

# LAW: the step. A cons cell's inversions are the elements of its tail that are
# strictly below the head, plus the inversions inside that tail: every inversion
# either has the head as its earlier element or it does not. This is the law
# that says what is being counted and which way the comparison points, and it is
# the one a body that counted elements instead of pairs, or that compared the
# two heads non-strictly, does not satisfy.
law count_inv_cons:
  for h: Nat
  for +t: List<&2, Nat>
  {S.count_inv(h <> t) == P.count_gt(h, t) + S.count_inv(t) : Nat}

# LAW: a list of equal elements has no inversions. It is the law about the
# *strictness* of the comparison rather than about the shape of one step: with
# every element equal to every other there is no pair `i < j` with `xs[i] >
# xs[j]`, whatever the length. It is inductive in `n`, and its step is the
# prelude's count of the elements below an element of the run, which is zero on
# a run of copies. A body whose comparison let equal elements count leaves the
# two sides of this law unconvertible.
law count_inv_replicate:
  for n: Nat
  for +a: Nat
  {S.count_inv(P.replicate(n, a)) == 0n : Nat}
