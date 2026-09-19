import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: walking an empty list from any running value produces no entries. Both
# sides compute, so this one is definitional, and it is the weak half: it fixes
# where the answer starts, and a body that answered `Nil{}` everywhere satisfies
# it.
law run_max_nil:
  for m: Nat
  {S.run_max(Nil{}, m) == Nil{} : List<Nat>}

# LAW: one element, one entry, and it is the larger of the running value and
# that element. Both sides compute, so this is definitional too, and it is the
# law that says the running value is *compared* rather than carried: a body that
# answered `m <> Nil{}` -- ignoring the element -- satisfies the composition law
# below whenever nothing in the list exceeds the running value, and leaves the
# two sides here unconvertible at any element that does.
law run_max_single:
  for h: Nat
  for m: Nat
  {S.run_max(h <> Nil{}, m) == P.max(m, h) <> Nil{} : List<Nat>}

# LAW: walking `append(xs, ys)` from `m` is walking `xs` from `m` and then
# walking `ys` from wherever the first walk left off. `append` matches on its
# first argument, so with a variable `xs` the goal does not reduce on its own:
# this one is inductive in `xs`, and its step case is the hypothesis at the tail
# with the head already folded into the running value.
law run_max_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for m: Nat
  {S.run_max(P.append(xs, ys), m) == P.append(S.run_max(xs, m), S.run_max(ys, P.after_max(xs, m))) : List<Nat>}
