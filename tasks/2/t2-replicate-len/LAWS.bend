import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: one more copy puts one more element in front. This is the law that pins
# the step: no body that ignores its arguments satisfies it, since the left
# side is then a constant and the right side is a cons cell.
law replicate_succ:
  for n: Nat
  for x: Nat
  {S.replicate(1n + n, x) == x <> S.replicate(n, x) : List<Nat>}

# LAW: the result has as many elements as were asked for. `len` matches on its
# first argument, so with a variable `n` the goal does not reduce on its own:
# this one is inductive in `n`, and it is what pins the count, which
# `replicate_succ` alone leaves open at zero.
law replicate_len:
  for n: Nat
  for x: Nat
  {P.len(S.replicate(n, x)) == n : Nat}
