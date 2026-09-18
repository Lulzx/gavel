import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: capping a one-element list caps that element. It is definitional, and it
# is the weak half: it says nothing about a longer list, so a body that got the
# singleton right and the rest wrong satisfies it.
law min_all_single:
  for h: Nat
  for n: Nat
  {S.min_all(h <> Nil{}, n) == P.min(h, n) <> Nil{} : List<Nat>}

# LAW: `min_all` distributes over a concatenation. Alone it is satisfied by the
# identity body, which maps a concatenation to itself; the base law is what
# rules that out. Together the two pin `min_all` -- one fixes a single element,
# and this one says the work is done element by element. `append` matches on its
# first argument, so with a variable `xs` the left-hand side does not reduce on
# its own: this one is inductive in `xs`.
law min_all_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for n: Nat
  {S.min_all(P.append(xs, ys), n) == P.append(S.min_all(xs, n), S.min_all(ys, n)) : List<Nat>}
