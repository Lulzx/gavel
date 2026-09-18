import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty count adds nothing up. This is the weak half: the constant body
# `0n` satisfies it, and so does a body that ignores the list and hands back its
# count.
law sum_prefix_zero:
  for xs: List<Nat>
  {S.sum_prefix(0n, xs) == 0n : Nat}

# LAW: adding up as many elements as the list has is adding up the list. `len`
# and `sum` both match on their first argument, so with a variable `xs` the
# left-hand side does not reduce on its own: this one is inductive in `xs`. It
# is the law that pins `sum_prefix` -- with the base law in hand, a body that
# ignored the count would have to be `0n` for every list and `sum(xs)` for every
# list at once.
law sum_prefix_len:
  for xs: List<Nat>
  {S.sum_prefix(P.len(xs), xs) == P.sum(xs) : Nat}

# LAW: once the list runs out the answer is zero. Neither law above reaches the
# inner `Nil{}`: `sum_prefix_zero` fixes only the count `0n`, and
# `sum_prefix_len` constrains only the diagonal, where the count and the list
# length agree -- so the case where the list is shorter than the count is
# unconstrained. Both `1n` and the remaining count proved the set at **tier 4,
# reward 1.000**.
law sum_prefix_nil:
  for k: Nat
  {S.sum_prefix(k, Nil{}) == 0n : Nat}
