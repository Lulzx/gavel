import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing is equal to a list with no elements. It is definitional, and it
# is the weak half: the constant body `0n` satisfies it.
law count_nil:
  for x: Nat
  {S.count(x, Nil{}) == 0n : Nat}

# LAW: the count of a cons is the head's indicator plus the count of the tail.
# Both sides compute, so this one is definitional too: it fixes the shape of
# the answer and rules out a body that returns the head's indicator alone, or
# the count of the tail alone. The constant body `0n` satisfies it only because
# `0n` is then added to `0n`; that a body cannot be *both* this and the laws
# below is what makes the set work.
law count_cons:
  for x: Nat
  for h: Nat
  for t: List<Nat>
  {S.count(x, h <> t) == P.is_eq(x, h) + S.count(x, t) : Nat}

# LAW: a list of one element counts one if that element is the one you asked
# about. Neither law above distinguishes the elements of the list from each
# other -- a body that counted through `P.len` would satisfy `count_nil` and
# would satisfy `count_cons` only if `P.is_eq` were constant -- so this is the
# law that pins the indicator. It is not definitional: `P.is_eq(x, x)` is only
# `1n` by an induction of its own, and the step then needs `1n + 0n` seen as
# `1n`, which `+` will not do on its own.
law count_self:
  for x: Nat
  {S.count(x, x <> Nil{}) == 1n : Nat}

# LAW: the count of an append is the sum of the counts. This is the induction,
# and `append` matches on its first argument, so with a variable list the goal
# does not reduce. Its step case is one use of the hypothesis plus a fact about
# how addition associates -- and that fact has to be stated so that the tail can
# be passed in an erased position, because a variable bound by `case h <> t:`
# may be used live only once per branch.
law count_append:
  for x: Nat
  for xs: List<Nat>
  for ys: List<Nat>
  {S.count(x, P.append(xs, ys)) == S.count(x, xs) + S.count(x, ys) : Nat}
