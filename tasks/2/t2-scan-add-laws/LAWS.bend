import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: walking an empty list from any starting total produces no totals. Both
# sides compute, so this one is definitional, and it is the weak half: it fixes
# where the answer starts, and a body that answered `Nil{}` everywhere satisfies
# it.
law scan_add_nil:
  for acc: Nat
  {S.scan_add(Nil{}, acc) == Nil{} : List<Nat>}

# LAW: one element, one running total, and it is the element added to the
# starting total. Both sides compute, so this is definitional too, and it is the
# law that says the accumulator is *used*: a body that answered `Nil{}` or the
# input list itself agrees with the composition law below whenever the elements
# it is walked over sum to nothing, and leaves the two sides here unconvertible.
law scan_add_single:
  for h: Nat
  for acc: Nat
  {S.scan_add(h <> Nil{}, acc) == (acc + h) <> Nil{} : List<Nat>}

# LAW: walking `append(xs, ys)` from `acc` is walking `xs` from `acc` and then
# walking `ys` from wherever the first walk ended. `append` matches on its first
# argument, so with a variable `xs` the goal does not reduce on its own: this one
# is inductive in `xs`, and its step case is the hypothesis at the tail with the
# head already folded into the accumulator.
law scan_add_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for acc: Nat
  {S.scan_add(P.append(xs, ys), acc) == P.append(S.scan_add(xs, acc), S.scan_add(ys, P.acc_after(xs, acc))) : List<Nat>}
