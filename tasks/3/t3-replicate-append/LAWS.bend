import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `n` copies of `x` have length `n`. This is the induction, and its step
# case is a `len` folded over a `replicate` that is one turn away from being a
# cons. It is not what pins the function: a body that returns `Nil{}` for every
# call has length zero and fails this law, but a body that returns the right
# number of copies of the *wrong* element satisfies it, which is why
# `replicate_single` is not optional.
law replicate_len:
  for n: Nat
  for x: Nat
  {P.len(S.replicate(n, x)) == n : Nat}

# LAW: `n + m` copies are the `n` copies followed by the `m` copies. This is
# where the task's step case has to generalise: the recursion is on the first
# count, so the second is a parameter of the induction rather than a literal,
# and the left-hand side only unfolds because a successor-added count still
# reduces. The constant body `Nil{}` is ruled out by the law above rather than
# by this one -- `P.append` on two `Nil{}`s is `Nil{}` on both sides here.
law replicate_append:
  for n: Nat
  for m: Nat
  for x: Nat
  {S.replicate(n + m, x) == P.append(S.replicate(n, x), S.replicate(m, x)) : List<Nat>}

# LAW: one copy of `x` is `x` on its own. The two laws above constrain the
# counts and the shape of the answer but never say which element it holds: a
# body that returns `n` zeroes satisfies both of them. This law is the one that
# pins the element, and it is the cons case of `replicate` at a literal count,
# so the policy closes it by unfolding its own definition.
law replicate_single:
  for x: Nat
  {S.replicate(1n, x) == x <> Nil{} : List<Nat>}

# LAW: a run of one repeated element reads the same backwards. `replicate_single`
# pins the element at one copy and `replicate_append` builds longer runs out of
# shorter ones, so this law is not what makes the answer unique -- it is the law
# that needs a lemma of its own. The step case is a `rev` whose scrutinee is a
# cons, which computes to a `snoc` of the shorter run, and the fact that a run
# with one more `x` on the right of it is one more copy of `x` is not
# definitional: it is an induction in its own right, and the step case cannot be
# closed without it.
law rev_replicate:
  for n: Nat
  for x: Nat
  {P.rev(S.replicate(n, x)) == S.replicate(n, x) : List<Nat>}
