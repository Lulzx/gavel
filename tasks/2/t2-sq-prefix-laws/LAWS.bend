import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty count adds no squares up. This is the weak half: the constant
# body `0n` satisfies it, and so does a body that ignores the list and hands
# back its count.
law sq_prefix_zero:
  for xs: List<Nat>
  {S.sq_prefix(0n, xs) == 0n : Nat}

# LAW: adding up as many squares as the list has elements is adding up the
# squares of the list. `len` and `sq_sum` both match on their first argument,
# so with a variable `xs` the left-hand side does not reduce on its own: this
# one is inductive in `xs`. It is the law that pins `sq_prefix` -- with the base
# law in hand, a body that ignored the count would have to be `0n` for every
# list and `sq_sum(xs)` for every list at once.
law sq_prefix_len:
  for xs: List<Nat>
  {S.sq_prefix(P.len(xs), xs) == P.sq_sum(xs) : Nat}
