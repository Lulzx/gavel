import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: mapping a one-element list adds `n` to that element. It is definitional,
# and it is the weak half: it says nothing about a list with more than one cell,
# so a body that got the singleton right and the rest wrong satisfies it.
law map_add_single:
  for h: Nat
  for n: Nat
  {S.map_add(h <> Nil{}, n) == (h + n) <> Nil{} : List<Nat>}

# LAW: `map_add` distributes over a concatenation, with `n` held fixed. Alone
# it is satisfied by the identity body, which maps a concatenation to itself;
# the base law is what rules that out. Together the two pin `map_add` -- one
# fixes what happens to a single element, and this one says the work is done
# element by element. `append` matches on its first argument, so with a variable
# `xs` the left-hand side does not reduce on its own: this one is inductive in
# `xs`.
law map_add_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for n: Nat
  {S.map_add(P.append(xs, ys), n) == P.append(S.map_add(xs, n), S.map_add(ys, n)) : List<Nat>}
