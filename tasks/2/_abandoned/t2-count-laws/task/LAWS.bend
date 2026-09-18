import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing occurs in the empty list. It is definitional, and it is the weak
# half: the constant body `0n` satisfies it.
law count_nil:
  for n: Nat
  {S.count(Nil{}, n) == 0n : Nat}

# LAW: adding one element on the right adds `eq(x, n)` to the count. `append`
# matches on its first argument, so with a variable `xs` the goal does not
# reduce on its own: this one is inductive in `xs`, and it is the law that pins
# `count`. Alone it is satisfied by a body that counts elements rather than
# occurrences of `n`: the right-hand side would have to be `1n` on the nose, and
# `eq(x, n)` is stuck on a variable `x`. The constant body `0n` fails it too,
# for the same reason.
law count_snoc:
  for xs: List<Nat>
  for x: Nat
  for n: Nat
  {S.count(P.append(xs, x <> Nil{}), n) == S.count(xs, n) + P.eq(x, n) : Nat}
