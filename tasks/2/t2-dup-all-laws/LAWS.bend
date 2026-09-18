import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: duplicating a one-element list duplicates that element. It is
# definitional, and it is the weak half: it says nothing about a longer list, so
# a body that got the singleton right and the rest wrong satisfies it.
law dup_all_single:
  for h: Nat
  {S.dup_all(h <> Nil{}) == h <> (h <> Nil{}) : List<Nat>}

# LAW: `dup_all` distributes over a concatenation. Alone it is satisfied by the
# identity body, which maps a concatenation to itself; the base law is what
# rules that out. Together the two pin `dup_all` -- one fixes a single element,
# and this one says the work is done element by element. `append` matches on its
# first argument, so with a variable `xs` the left-hand side does not reduce on
# its own: this one is inductive in `xs`.
law dup_all_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.dup_all(P.append(xs, ys)) == P.append(S.dup_all(xs), S.dup_all(ys)) : List<Nat>}
