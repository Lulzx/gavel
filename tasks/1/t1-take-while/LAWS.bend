import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there is nothing to take from an empty list. Both sides compute, so this
# one is definitional, and it is the weak half: it fixes the answer where the
# list has already run out and leaves every other input to the two laws below.
law take_while_nil:
  for n: Nat
  {S.take_while(Nil{}, n) == Nil{} : List<Nat>}

# LAW: while the head is at most the threshold the head is kept, and the answer
# is that head in front of the answer for the tail. The premise is the
# predicate's own answer and it is what makes the law *say* anything: with `h`
# and `n` variables `P.le(h, n)` is stuck, so without the premise both sides are
# terms nothing can reduce. It is also half of what pins the function: a body
# that answered `Nil{}` for every list satisfies `take_while_nil` and fails
# here.
law take_while_keep:
  for h: Nat
  for t: List<Nat>
  for n: Nat
  for e: {P.le(h, n) == True{} : Bool}
  {S.take_while(h <> t, n) == h <> S.take_while(t, n) : List<Nat>}

# LAW: the first head above the threshold stops the walk, and nothing of the
# list comes back. This is the other half of the pin, and it is not implied by
# `take_while_keep`: a body that kept every element -- the identity on the list
# -- satisfies the keep law and is killed here, and so is one that ignored the
# predicate and handed the whole list back after a single step.
law take_while_stop:
  for y: Nat
  for t: List<Nat>
  for n: Nat
  for e: {P.le(y, n) == False{} : Bool}
  {S.take_while(y <> t, n) == Nil{} : List<Nat>}
