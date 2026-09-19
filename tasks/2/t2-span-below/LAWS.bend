import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list spans into two empty lists. Both sides compute, so this
# one is definitional, and it is the weak half: it fixes the pair where there is
# nothing to split and leaves every other input to the laws below.
law span_below_nil:
  for n: Nat
  {S.span_below(Nil{}, n) == P.MkL{Nil{}, Nil{}} : P.PairL}

# LAW: while the head is at most the threshold it joins the front and the back
# is the back of the tail's pair. The premise is the predicate's own answer and
# it is what makes the law say anything: with `h` and `n` variables
# `P.le(h, n)` is stuck, so neither side reduces without it. The law is the one
# that says the two halves come from *one* recursion rather than two -- a body
# that put every element in the front, or every element in the back, leaves the
# two sides here unconvertible because `P.span_put` puts the head on the front
# and takes the back from the tail's pair.
law span_below_keep:
  for +h: Nat
  for +t: List<&2, Nat>
  for +n: Nat
  for e: {P.le(h, n) == True{} : Bool}
  {S.span_below(h <> t, n) == P.MkL{h <> P.front(S.span_below(t, n)), P.back(S.span_below(t, n))} : P.PairL}

# LAW: at the first head above the threshold the walk stops: the front is empty
# and the back is the whole list from that head, unchanged. This is the law that
# pins the stopping case, and it is the only one that reaches it: in
# `span_below_keep` the tail's pair is what the front and back are read off, so
# a body that answered a pair with the right *shape* there and then lost the
# list on the way back is killed only here.
law span_below_stop:
  for +y: Nat
  for t: List<&2, Nat>
  for n: Nat
  for e: {P.le(y, n) == False{} : Bool}
  {S.span_below(y <> t, n) == P.MkL{Nil{}, y <> t} : P.PairL}

# LAW: the two halves have between them as many elements as the input. This is
# the work, and neither cons law above nor the pin implies it: they say which
# elements are in which half, and this says none is lost and none is counted
# twice. Nothing reduces on its own -- `S.span_below` of a variable list is
# stuck, so the induction hypothesis is the only thing that can rewrite the goal
# -- and the step needs `P.len` of the pair the cons step produced, which is a
# fact about `P.span_put` that the prelude does not state.
law span_below_len:
  for +xs: List<&2, Nat>
  for +n: Nat
  {P.len(P.front(S.span_below(xs, n))) + P.len(P.back(S.span_below(xs, n))) == P.len(xs) : Nat}
