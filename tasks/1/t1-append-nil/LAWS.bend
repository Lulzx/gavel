import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: appending the empty list on the right changes nothing. This one is
# inductive in `xs`: `append` matches on its first argument, so it does not
# reduce on a variable.
law append_nil:
  for xs: List<Nat>
  {S.append(xs, Nil{}) == xs : List<Nat>}

# LAW: appending the empty list on the left changes nothing. This is the law
# that pins `append` from below: the projection `append(xs, ys) = xs` satisfies
# `append_nil` definitionally, and it cannot satisfy this one (`Nil{}` is not
# `ys`).
law append_nil_left:
  for ys: List<Nat>
  {S.append(Nil{}, ys) == ys : List<Nat>}

# LAW: `append` conses the head of its first argument onto the append of the
# tails. This is the law that pins the cons case: the projection onto the second
# argument, `append(xs, ys) = ys`, satisfies `append_nil_left` and cannot
# satisfy this one.
law append_cons:
  for x: Nat
  for xs: List<Nat>
  for ys: List<Nat>
  {S.append(x <> xs, ys) == x <> S.append(xs, ys) : List<Nat>}
