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

# LAW: an exhausted count adds no squares up, whatever the count. `sq_prefix_len`
# constrains only the diagonal, where the count and the length agree, so the
# inner `Nil{}` case -- the list running out before the count -- is reached by
# neither law: a body answering `1n` there, or handing back the rest of the
# count, proved both at full reward. Definitional in both cases of the count.
law sq_prefix_nil:
  for k: Nat
  {S.sq_prefix(k, Nil{}) == 0n : Nat}

# LAW: one step of the walk. The three laws above fix `sq_prefix` where the count
# is `0n`, where the list is `Nil{}`, and on the diagonal where the count is the
# list's length -- and nowhere else. A body that answers the whole list's total
# for any nonzero count satisfies all three and is wrong at every count strictly
# between `0n` and the length: **measured** by `tools/holes.py`, which found two
# shipped mutants doing exactly that while V2 read them as killed, because the
# reference proof of the length law did not fit their shape. This law is the
# interior: with the zero and nil laws it determines `sq_prefix` everywhere.
law sq_prefix_step:
  for k: Nat
  for h: Nat
  for t: List<Nat>
  {S.sq_prefix(1n + k, h <> t) == P.sq(h) + S.sq_prefix(k, t) : Nat}
