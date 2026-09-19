import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty first list matches nothing. It is definitional -- the match on
# `xs` steps on `Nil{}` and answers `0n` without looking at `ys` -- and it is
# the weak half: the constant body `0n` satisfies it. It fixes the answer when
# there is nothing left to compare, which is the case the cons law below never
# reaches.
law count_matches_nil:
  for ys: List<Nat>
  {S.count_matches(Nil{}, ys) == 0n : Nat}

# LAW: an empty second list matches nothing, however long the first is. The
# left-hand side is ground in its second argument: `count_matches` steps on the
# cons cell and then finds `Nil{}` where it wants a second element, so it
# answers `0n` outright. The cons law below cannot see this answer either -- it
# names its second argument as `k <> u` -- so this is the law that rules out a
# body whose stopped match answers anything but zero.
law count_matches_nil_right:
  for h: Nat
  for t: List<Nat>
  {S.count_matches(h <> t, Nil{}) == 0n : Nat}

# LAW: two cons cells agree at the head and then at the tail. Both sides
# compute, so this is the definition written out, and it is the law that says
# *which* elements are compared: a body that weighed the head against the wrong
# element, or that recursed on the wrong tail, leaves the two sides unequal.
# It is what ties the count to the elements themselves rather than to the two
# lengths, which the self law below cannot do on its own.
law count_matches_cons:
  for h: Nat
  for k: Nat
  for t: List<Nat>
  for u: List<Nat>
  {S.count_matches(h <> t, k <> u) == P.pick(P.eq(h, k), 1n, 0n) + S.count_matches(t, u) : Nat}

# LAW: a list agrees with itself everywhere, so its self-count is its length.
# This is the law with content, and it is inductive in `xs`: `eq(x, x)` on a
# variable does not reduce, so the step has to establish that the head agrees
# with itself before the weight computes, and the hypothesis carries the tail.
# The constant body `0n` fails it, because the right-hand side is the length,
# and a body that always answered the length fails `count_matches_cons`.
law count_matches_self:
  for xs: List<Nat>
  {S.count_matches(xs, xs) == P.len(xs) : Nat}
