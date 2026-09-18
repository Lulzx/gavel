import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: taking a one-element list back one step takes its element back one step.
# It is definitional, and it is the weak half: it says nothing about a longer
# list, so a body that got the singleton right and the rest wrong satisfies it.
law pred_all_single:
  for h: Nat
  {S.pred_all(h <> Nil{}) == P.pred(h) <> Nil{} : List<Nat>}

# LAW: `pred_all` distributes over a concatenation. Alone it is satisfied by the
# identity body, which maps a concatenation to itself; the base law is what
# rules that out. Together the two pin `pred_all` -- one fixes a single element,
# and this one says the work is done element by element. `append` matches on its
# first argument, so with a variable `xs` the left-hand side does not reduce on
# its own: this one is inductive in `xs`.
law pred_all_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.pred_all(P.append(xs, ys)) == P.append(S.pred_all(xs), S.pred_all(ys)) : List<Nat>}
