import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: mapping a one-element list maps that element. It is definitional, and it
# is the weak half: it says nothing about a list with more than one cell, so a
# body that got the singleton right and the rest wrong satisfies it.
law cube_all_single:
  for h: Nat
  {S.cube_all(h <> Nil{}) == (P.cube(h)) <> Nil{} : List<Nat>}

# LAW: `cube_all` distributes over a concatenation. Alone it is satisfied by the
# identity body, which maps a concatenation to itself; the base law is what
# rules that out. Together the two pin `cube_all` -- one fixes what happens to a
# single element, and this one says the work is done element by element.
# `append` matches on its first argument, so with a variable `xs` the left-hand
# side does not reduce on its own: this one is inductive in `xs`.
law cube_all_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.cube_all(P.append(xs, ys)) == P.append(S.cube_all(xs), S.cube_all(ys)) : List<Nat>}
