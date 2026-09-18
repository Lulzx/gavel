import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the first `n` elements followed by the rest are the list you started
# with. This is the law that pins the two functions against each other, and the
# only one whose right-hand side is the whole argument. A body that ignored the
# list -- a fixed `Nil{}`, or a run of zeros -- leaves the left-hand side stuck
# on a variable, and a body that ignored the count gives
# `P.append(xs, S.drop(n, xs)) == xs`, which `{==}` cannot prove either: with
# `S.take` returning `xs` the left-hand side is `P.append(xs, S.drop(n, xs))`,
# and `P.append` does not reduce on a variable.
law take_drop:
  for n: Nat
  for xs: List<Nat>
  {P.append(S.take(n, xs), S.drop(n, xs)) == xs : List<Nat>}

# LAW: dropping in two steps is dropping the sum in one. This is the law about
# `drop` on its own: `take_drop` constrains the two functions only through
# their composition, and a `drop` that ignored its count would still compose
# with a `take` that undoes it. The induction is on the first count -- the one
# the reference steps on -- and the second count is a parameter throughout.
# The constant body `Nil{}` fails it as well: the left-hand side is `Nil{}` and
# the right-hand side is `S.drop(n + m, xs)`, which is stuck.
law drop_drop:
  for n: Nat
  for m: Nat
  for xs: List<Nat>
  {S.drop(m, S.drop(n, xs)) == S.drop(n + m, xs) : List<Nat>}

# LAW: no more elements come back than were asked for or were there. This is
# `take`'s own law, and it is stated exactly rather than as a bound: the length
# is `P.min(n, P.len(xs))`, so it says which of the two ran out. It is what
# rules out a `take` that keeps the count and returns the wrong elements --
# together with `take_drop`, which says the two halves are the argument -- and
# `drop_drop` says nothing about `take` at all, so none of the three is optional.
law take_len:
  for n: Nat
  for xs: List<Nat>
  {P.len(S.take(n, xs)) == P.min(n, P.len(xs)) : Nat}
