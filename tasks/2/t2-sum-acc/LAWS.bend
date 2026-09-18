import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: summing a one-element list onto a zero accumulator is that element. This
# is the law that pins the cons case: `sum_acc_append` is satisfied both by a
# `sum_acc` whose body is `0n` -- both of its sides are then `0n` -- and by one
# whose body is its accumulator -- both of its sides are then that accumulator.
# Neither of those bodies survives this law.
law sum_acc_single:
  for h: Nat
  {S.sum_acc(h <> Nil{}, 0n) == h : Nat}

# LAW: summing a concatenation onto an accumulator is summing the two pieces
# onto it in turn, the second piece innermost. `append` matches on its first
# argument, so with a variable `xs` the goal does not reduce on its own: this
# one is inductive in `xs`, and it is what pins where each element is added,
# since `sum_acc_single` alone says nothing about a longer list.
law sum_acc_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for acc: Nat
  {S.sum_acc(P.append(xs, ys), acc) == S.sum_acc(ys, S.sum_acc(xs, acc)) : Nat}
