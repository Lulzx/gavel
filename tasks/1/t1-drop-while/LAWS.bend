import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there is nothing to drop from an empty list. Definitional, and the weak
# half: it fixes the answer where the list has already run out.
law drop_while_nil:
  for n: Nat
  {S.drop_while(Nil{}, n) == Nil{} : List<&2, Nat>}

# LAW: while the head is at most the threshold it is dropped and the answer is
# the answer for the tail. The premise is the predicate's own answer, and it is
# what makes the law say anything: with `h` and `n` variables `P.le(h, n)` is
# stuck, so without it neither side reduces. This is one half of the pin -- a
# body that dropped nothing, i.e. the identity on the list, has `h <> t` here
# against the recursion's answer for the tail, which is not the same term.
law drop_while_keep:
  for h: Nat
  for t: List<&2, Nat>
  for n: Nat
  for e: {P.le(h, n) == True{} : Bool}
  {S.drop_while(h <> t, n) == S.drop_while(t, n) : List<&2, Nat>}

# LAW: at the first head above the threshold the walk stops and the rest of the
# list, that head included, comes back unchanged. This is the other half of the
# pin: a body that dropped the whole list satisfies `drop_while_nil` and
# `drop_while_keep` -- both right-hand sides are recursively stuck -- and is
# killed only here, where the right-hand side is a cons cell.
law drop_while_stop:
  for y: Nat
  for t: List<&2, Nat>
  for n: Nat
  for e: {P.le(y, n) == False{} : Bool}
  {S.drop_while(y <> t, n) == y <> t : List<&2, Nat>}
