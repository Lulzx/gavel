import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: one step of the count keeps one cons cell. This is the weak half: a
# `take` whose body is its list argument -- ignoring the count -- satisfies it,
# because both sides are then `h <> xs`. The second law is what rules that out.
law take_succ:
  for h: Nat
  for k: Nat
  for xs: List<Nat>
  {S.take(1n + k, h <> xs) == h <> S.take(k, xs) : List<Nat>}

# LAW: keeping as many elements as `xs` has takes all of `xs`, whenever `ys` is
# what follows it. `append` and `len` both match on their first argument, so
# with a variable `xs` the goal does not reduce on its own: this one is
# inductive in `xs`. It is the law that pins `take`: a body that ignored the
# count would keep all of `xs <> ys` and a body that ignored the list would
# keep nothing, and neither hands back `xs`.
law take_append_len:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.take(P.len(xs), P.append(xs, ys)) == xs : List<Nat>}

# LAW: there is nothing to take from an empty list. Neither law above reaches
# the inner `Nil{}`: `take_succ` always hands it a cons cell, and
# `take_append_len` reaches the count `0n` only in its own empty case, which
# answers before the inner match. So the case where the count is positive and
# the list has run out is unconstrained -- a body answering a one-element list
# there proves both at tier 4, reward 1.000.
law take_nil:
  for k: Nat
  {S.take(k, Nil{}) == Nil{} : List<Nat>}
