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

# LAW: once the list runs out the answer is zero. Neither law above reaches the
# inner `Nil{}`: `zeros_prefix_zero` fixes only the count `0n`, and
# `zeros_prefix_len` constrains only the diagonal, where the count and the list
# length agree -- so the case where the list is shorter than the count is
# unconstrained. A body answering `1n`, or the remaining count, there proves
# both at tier 4, reward 1.000.
law zeros_prefix_nil:
  for k: Nat
  {S.zeros_prefix(k, Nil{}) == 0n : Nat}

# LAW: one step of the walk. The three laws above fix `zeros_prefix` where the count
# is `0n`, where the list is `Nil{}`, and on the diagonal where the count is the
# list's length -- and nowhere else. A body that answers the whole list's total
# for any nonzero count satisfies all three and is wrong at every count strictly
# between `0n` and the length: **measured** by `tools/holes.py`, which found two
# shipped mutants doing exactly that while V2 read them as killed, because the
# reference proof of the length law did not fit their shape. This law is the
# interior: with the zero and nil laws it determines `zeros_prefix` everywhere.
law zeros_prefix_step:
  for k: Nat
  for h: Nat
  for t: List<Nat>
  {S.zeros_prefix(1n + k, h <> t) == P.is_zero(h) + S.zeros_prefix(k, t) : Nat}
