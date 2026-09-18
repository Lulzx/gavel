import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: one step of the count removes one cons cell. This is the weak half: a
# `drop` whose body is `Nil{}` -- ignoring both arguments -- satisfies it,
# because both sides are then `Nil{}`. The second law is what rules that out.
law drop_succ:
  for k: Nat
  for h: Nat
  for t: List<Nat>
  {S.drop(1n + k, h <> t) == S.drop(k, t) : List<Nat>}

# LAW: dropping as many elements as `xs` has leaves `ys`, the rest of
# `xs <> ys`. `append` and `len` both match on their first argument, so with a
# variable `xs` the goal does not reduce on its own: this one is inductive in
# `xs`. It is the law that pins `drop`: a body that ignored the count would
# hand back `xs <> ys` on the left and a body that ignored the list would hand
# back the empty list, and neither matches `ys`.
law drop_append_len:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.drop(P.len(xs), P.append(xs, ys)) == ys : List<Nat>}

# LAW: when the list runs out before the count, the answer is the empty list.
# Neither law above reaches that case: `drop_succ`'s left-hand side pairs a
# successor count with a cons cell, and `drop_append_len`'s `append(xs, ys)` is
# never empty when `len(xs)` is a successor. So the inner `case Nil{}` is
# orphaned without this one, and a body answering `k <> Nil{}` -- the rest of
# the count, as a singleton -- proved every law at reward 1.000.
law drop_nil:
  for k: Nat
  {S.drop(k, Nil{}) == Nil{} : List<Nat>}
