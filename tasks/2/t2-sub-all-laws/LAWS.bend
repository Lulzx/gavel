import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: taking one step back off a one-element list takes the step off its
# element. It is definitional, and it is the weak half: it says nothing about a
# longer list, so a body that got the singleton right and the rest wrong
# satisfies it.
law sub_all_single:
  for h: Nat
  for n: Nat
  {S.sub_all(h <> Nil{}, n) == P.sub(h, n) <> Nil{} : List<Nat>}

# LAW: `sub_all` distributes over a concatenation. Alone it is satisfied by the
# identity body, which maps a concatenation to itself; the base law is what
# rules that out. Together the two pin `sub_all` -- one fixes a single element,
# and this one says the work is done element by element. `append` matches on its
# first argument, so with a variable `xs` the left-hand side does not reduce on
# its own: this one is inductive in `xs`.
law sub_all_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for n: Nat
  {S.sub_all(P.append(xs, ys), n) == P.append(S.sub_all(xs, n), S.sub_all(ys, n)) : List<Nat>}
