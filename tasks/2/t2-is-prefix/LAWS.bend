import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list is a prefix of every list. It is definitional -- the
# match on `xs` steps on `Nil{}` and answers `True{}` without looking at `ys`
# -- and it is the weak half: the constant body `True{}` satisfies it. It fixes
# the answer when there is nothing left to match, which is the case the cons
# laws below never reach.
law is_prefix_nil:
  for ys: List<Nat>
  {S.is_prefix(Nil{}, ys) == True{} : Bool}

# LAW: no non-empty list is a prefix of the empty list. The left-hand side is
# ground in its second argument: `is_prefix` steps on the cons cell and then
# finds `Nil{}` where it wants a second element, so it answers `False{}`
# outright. The cons law below cannot see this answer either -- it names its
# second argument as `k <> u` -- so this is the law that rules out a body whose
# `Nil{}` case answers `True{}`.
law is_prefix_nil_right:
  for h: Nat
  for t: List<Nat>
  {S.is_prefix(h <> t, Nil{}) == False{} : Bool}

# LAW: a cons cell is a prefix of another cons cell exactly when the heads are
# equal and the tails are a prefix. Both sides compute, so this is the
# definition written out, and it is the law that says *which* elements have to
# line up: a body that compared `h` against the tail's head, or that recursed
# on the wrong tail, leaves the two sides unequal. It is satisfied by every
# body of the right shape, which is why the two append laws below are not
# optional -- by itself it says nothing about a list longer than one element
# beyond where the recursion is handed.
law is_prefix_cons:
  for h: Nat
  for k: Nat
  for t: List<Nat>
  for u: List<Nat>
  {S.is_prefix(h <> t, k <> u) == Bool.and(P.eq(h, k), S.is_prefix(t, u)) : Bool}

# LAW: prefixing `ys` with `xs` makes `xs` a prefix. This is the law with
# content, and it is inductive in `xs`: `append` matches on its first argument,
# so with a variable `xs` the left-hand side does not reduce on its own, and
# the hypothesis has to carry the comparison of the heads out of the `and` one
# element at a time. A body that stopped after the first element -- and the
# constant body `False{}` -- fails it, because the right-hand side is `True{}`
# at every length.
law is_prefix_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.is_prefix(xs, P.append(xs, ys)) == True{} : Bool}

# LAW: every list is a prefix of itself. `is_prefix_append` does not give this
# one away, because `append(xs, Nil{})` is not `xs` to the checker: a body
# whose cons case answered `False{}` as soon as the *tails* were equal but not
# identical would satisfy nothing here. It is the second law with content, and
# it is what ties the answer to the second argument's own elements rather than
# to a list built around them.
law is_prefix_self:
  for xs: List<Nat>
  {S.is_prefix(xs, xs) == True{} : Bool}
