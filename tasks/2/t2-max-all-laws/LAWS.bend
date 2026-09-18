import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: raising the ceiling of a one-element list raises that element. It is
# definitional, and it is the weak half: it says nothing about a longer list, so
# a body that got the singleton right and the rest wrong satisfies it.
law max_all_single:
  for h: Nat
  for n: Nat
  {S.max_all(h <> Nil{}, n) == P.max(h, n) <> Nil{} : List<Nat>}

# LAW: `max_all` distributes over a concatenation. Alone it is satisfied by the
# identity body, which maps a concatenation to itself; the base law is what
# rules that out. Together the two pin `max_all` -- one fixes a single element,
# and this one says the work is done element by element. `append` matches on its
# first argument, so with a variable `xs` the left-hand side does not reduce on
# its own: this one is inductive in `xs`.
law max_all_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for n: Nat
  {S.max_all(P.append(xs, ys), n) == P.append(S.max_all(xs, n), S.max_all(ys, n)) : List<Nat>}
