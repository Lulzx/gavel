import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list adds up to nothing. It is definitional -- the match on
# `Nil{}` answers `0n` without looking at the tail -- and it is the weak half:
# the constant body `0n` satisfies it.
law sum_nonzero_nil:
  {S.sum_nonzero(Nil{}) == 0n : Nat}

# LAW: adding one element on the right adds whether that element is nonzero.
# `append` matches on its first argument, so with a variable `xs` the goal does
# not reduce on its own: this one is inductive in `xs`, and it is the law that
# pins `sum_nonzero`. A body that counted elements rather than nonzero ones
# fails it -- the right-hand side would have to be `1n` on the nose, and
# `is_nonzero(x)` is stuck on a variable `x` -- and the constant body `0n` fails
# it too, for the same reason.
law sum_nonzero_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.sum_nonzero(P.append(xs, x <> Nil{})) == S.sum_nonzero(xs) + P.is_nonzero(x) : Nat}
