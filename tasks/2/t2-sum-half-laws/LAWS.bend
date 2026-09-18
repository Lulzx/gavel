import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list adds up to nothing. It is definitional -- the match on
# `Nil{}` answers `0n` without looking at the tail -- and it is the weak half:
# the constant body `0n` satisfies it.
law sum_half_nil:
  {S.sum_half(Nil{}) == 0n : Nat}

# LAW: adding one element on the right adds the halving of that element.
# `append` matches on its first argument, so with a variable `xs` the goal does
# not reduce on its own: this one is inductive in `xs`, and it is the law that
# pins `sum_half`. Alone it is satisfied by a body that summed the elements
# rather than halving them -- the right-hand side would have to be `half(x)` on
# the nose, and `x` is stuck -- and the constant body `0n` fails it for the same
# reason.
law sum_half_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.sum_half(P.append(xs, x <> Nil{})) == S.sum_half(xs) + P.half(x) : Nat}
