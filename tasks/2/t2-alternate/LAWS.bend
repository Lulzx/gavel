import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a count of zero alternates nothing. The left-hand side is ground in the
# argument the match consumes, so this is the answer the recursion reaches when
# it has already stopped, and no other law here reaches it -- the cons law names
# its count as `1n + n`. It is the weak half on its own: the constant body
# `Nil{}` satisfies it.
law alternate_zero:
  for a: Nat
  for b: Nat
  {S.alternate(0n, a, b) == Nil{} : List<Nat>}

# LAW: one more to go puts the first number on the front and hands the rest of
# the work to the same function with the two numbers swapped. Both sides
# compute, so this is the definition written out, and it is the law that pins
# the order: a body that kept `a` in front of every step answers a constant
# list and leaves the two sides unequal.
law alternate_cons:
  for n: Nat
  for a: Nat
  for b: Nat
  {S.alternate(1n+n, a, b) == a <> S.alternate(n, b, a) : List<Nat>}

# LAW: at two elements the alternation is `a` and then `b`. The count is a
# literal, so both sides compute all the way down and the swap at the step is
# the only thing left; it is what a body that got the two the wrong way round
# fails, and it is the only law here whose right-hand side names the second
# number as an element.
law alternate_two:
  for a: Nat
  for b: Nat
  {S.alternate(2n, a, b) == a <> b <> Nil{} : List<Nat>}

# LAW: the answer is as long as the count it was given. This is the law with
# content, and it is inductive in `n`: the right-hand side counts the argument
# itself, so a body that dropped a step, or answered a constant list of the
# wrong size, fails it. `len` matches on its first argument, so with a variable
# `n` neither side reduces on its own.
law alternate_len:
  for n: Nat
  for a: Nat
  for b: Nat
  {P.len(S.alternate(n, a, b)) == n : Nat}
