import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: one step of the count steps one cons cell in. This is the weak half: both
# sides are `at` applied to the same tail, so a body that ignores its arguments
# and returns one constant satisfies it. The second law is what rules that out.
law at_succ:
  for h: Nat
  for k: Nat
  for xs: List<Nat>
  {S.at(h <> xs, 1n + k) == S.at(xs, k) : Nat}

# LAW: the element sitting at position `len(xs)` of `xs <> [y]` is `y`. `append`
# and `len` both match on their first argument, so with a variable `xs` neither
# side reduces on its own: this one is inductive in `xs`. It is the law that
# pins `at` -- a body that ignored the list and handed back the count would have
# to return `y` for every `y`, and a constant body cannot return it at all.
law at_len_append:
  for xs: List<Nat>
  for y: Nat
  {S.at(P.append(xs, y <> Nil{}), P.len(xs)) == y : Nat}

# LAW: nothing is at any position of the empty list. Neither law above lands on
# that case -- `at_succ`'s left side is a cons cell, and `at_len_append`'s is
# `append(xs, ·)`, which is never `Nil{}` -- so without this one the empty case
# is unconstrained and a body answering `1n` there proves every law in the set.
# The law is definitional and is here for coverage, not for arithmetic: it is
# the case the induction at `xs` in `at_len_append` starts from.
law at_nil:
  for n: Nat
  {S.at(Nil{}, n) == 0n : Nat}
