import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there is nothing to count in an empty list. Both sides compute, so this
# one is definitional and it is the weak half: it fixes the answer where the
# list has run out, and it also rules out a body that ignored its argument and
# answered with the threshold, since `n` is a variable here.
law count_while_nil:
  for n: Nat
  {S.count_while(Nil{}, n) == 0n : Nat}

# LAW: while the head is at most the threshold it is counted and the answer is
# one more than the answer for the tail. The premise is the predicate's own
# answer and it is what makes the law say anything: with `h` and `n` variables
# `P.le(h, n)` is stuck, so without it neither side reduces. It is one half of
# the pin -- a body that answered `0n` for every list has the wrong value on
# the left of this equation.
law count_while_keep:
  for h: Nat
  for t: List<Nat>
  for n: Nat
  for e: {P.le(h, n) == True{} : Bool}
  {S.count_while(h <> t, n) == 1n + S.count_while(t, n) : Nat}

# LAW: the first head above the threshold stops the walk and nothing further is
# counted. This is the other half of the pin: a body that counted every element
# satisfies `count_while_nil` and `count_while_keep` and is killed only here,
# where the count has to come back to `0n` rather than carry the tail's.
law count_while_stop:
  for y: Nat
  for t: List<Nat>
  for n: Nat
  for e: {P.le(y, n) == False{} : Bool}
  {S.count_while(y <> t, n) == 0n : Nat}
