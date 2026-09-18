import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty count counts no zeros. This is the weak half: the constant body
# `0n` satisfies it, and so does a body that ignores the list and hands back its
# count.
law zeros_prefix_zero:
  for xs: List<Nat>
  {S.zeros_prefix(0n, xs) == 0n : Nat}

# LAW: counting the zeros of as many elements as the list has is counting the
# zeros of the list. `len` and `count_zeros` both match on their first argument,
# so with a variable `xs` the left-hand side does not reduce on its own: this one
# is inductive in `xs`. It is the law that pins `zeros_prefix` -- with the base
# law in hand, a body that ignored the count would have to be `0n` for every
# list and `count_zeros(xs)` for every list at once.
law zeros_prefix_len:
  for xs: List<Nat>
  {S.zeros_prefix(P.len(xs), xs) == P.count_zeros(xs) : Nat}
