import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty count takes the maximum of nothing. This is the weak half: the
# constant body `0n` satisfies it, and so does a body that ignores the list and
# hands back its count.
law max_prefix_zero:
  for xs: List<Nat>
  {S.max_prefix(0n, xs) == 0n : Nat}

# LAW: taking as many elements as the list has is taking the maximum of the
# list. `len` and `max_list` both match on their first argument, so with a
# variable `xs` the left-hand side does not reduce on its own: this one is
# inductive in `xs`. It is the law that pins `max_prefix` -- with the base law
# in hand, a body that ignored the count would have to be `0n` for every list
# and `max_list(xs)` for every list at once.
law max_prefix_len:
  for xs: List<Nat>
  {S.max_prefix(P.len(xs), xs) == P.max_list(xs) : Nat}

# LAW: once the list runs out the answer is zero. Neither law above reaches the
# inner `Nil{}`: `max_prefix_zero` fixes only the count `0n`, and
# `max_prefix_len` constrains only the diagonal, where the count and the list
# length agree -- so the case where the list is shorter than the count is
# unconstrained. Both `1n` and the remaining count proved the set at **tier 4,
# reward 1.000**.
law max_prefix_nil:
  for k: Nat
  {S.max_prefix(k, Nil{}) == 0n : Nat}
