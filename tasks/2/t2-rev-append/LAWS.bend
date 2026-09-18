import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: reversing a one-element list onto an accumulator puts that element in
# front of it. This is the law that pins the cons case: `rev_append_append` is
# satisfied both by a `rev_append` whose body is `Nil{}` -- both of its sides
# are then `Nil{}` -- and by one whose body is its second argument -- both of
# its sides are then that argument. Neither of those bodies survives this law.
law rev_append_single:
  for h: Nat
  for ys: List<Nat>
  {S.rev_append(h <> Nil{}, ys) == h <> ys : List<Nat>}

# LAW: reversing a concatenation onto an accumulator is reversing the two
# pieces onto it in turn, the second piece outermost. `append` matches on its
# first argument, so with a variable `xs` the goal does not reduce on its own:
# this one is inductive in `xs`, and it is what pins the accumulator, since
# `rev_append_single` alone says nothing about a list longer than one element.
law rev_append_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for zs: List<Nat>
  {S.rev_append(P.append(xs, ys), zs) == S.rev_append(ys, S.rev_append(xs, zs)) : List<Nat>}
