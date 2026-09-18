import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the sum of `n` copies of `x` is `n * x`. This is the induction, and its
# step case is a `sum` over a run that is one turn away from being a cons. The
# constant body `0n` fails it -- the left-hand side computes and the right-hand
# side is `P.mul(n, x)`, stuck on a variable -- and so does a body that counts
# the list instead of adding it, `S.sum(xs) = P.len(xs)`, which gives `n` on
# the left and `P.mul(n, x)` on the right.
law sum_replicate_mul:
  for n: Nat
  for x: Nat
  {S.sum(P.replicate(n, x)) == P.mul(n, x) : Nat}

# LAW: the sum of `n` ones is `n`. The law above constrains the answer against
# a fixed multiplier but says nothing about *which* element is being summed: a
# body that adds up the zeros would still satisfy it, since `P.mul(n, 0n)` is
# `0n` on both sides. This law pins the element, and it is the reason the policy
# cannot define `sum` as a length. It is an induction of its own -- the law
# above may not be cited, and neither may any other law -- but its step case
# closes by unfolding once and applying the hypothesis.
law sum_replicate_one:
  for n: Nat
  {S.sum(P.replicate(n, 1n)) == n : Nat}

# LAW: the sum of a cons is the head plus the sum of the tail. Both sides
# compute, so this one is definitional: it constrains the shape of the answer
# rather than a measure of it, and it is what rules out a `sum` that returns the
# head alone or the tail alone, either of which would leave a variable on the
# right.
law sum_cons:
  for h: Nat
  for t: List<Nat>
  {S.sum(h <> t) == h + S.sum(t) : Nat}
