import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there are no gaps in the empty list, so no separators either -- and in
# particular not one separator. Both sides compute, so this is definitional, and
# it is a pin: it fixes the answer on the empty input, which the step law below
# never reaches.
law intersperse_nil:
  for sep: Nat
  {S.intersperse(Nil{}, sep) == Nil{} : List<&2, Nat>}

# LAW: a one-element list has no gap either, so the separator does not appear.
# Both sides compute, so this is definitional too, and it is the half of the pin
# that the empty list does not cover: a body that answered `sep <> Nil{}` here
# would satisfy `intersperse_nil`, and this law names `x <> Nil{}`, which the
# step law below does not reach.
law intersperse_single:
  for x: Nat
  for sep: Nat
  {S.intersperse(x <> Nil{}, sep) == x <> Nil{} : List<&2, Nat>}

# LAW: the step. Two or more elements answer the first, then the separator, then
# the interspersing of everything from the second element on. Both sides compute,
# so this is definitional, and it is the law that says where the separators go:
# a body that put the separator in front of the head, or that recursed on `t`
# alone -- dropping the second element and with it one separator -- leaves the
# two sides unconvertible here.
law intersperse_cons:
  for a: Nat
  for b: Nat
  for t: List<&2, Nat>
  for sep: Nat
  {S.intersperse(a <> (b <> t), sep) == a <> (sep <> S.intersperse(b <> t, sep)) : List<&2, Nat>}

# LAW: the count half, and the only law here that is not definitional. The list
# is a variable, so `intersperse` cannot take a step and the two sides do not
# compute: this law is a real induction on `xs`, and it is what says how many
# separators come out, where the law above says which list they land in.
#
# `P.ilen(xs)` is the length the answer must have -- one element for the head
# plus two for every element after it -- and it is stated without mentioning
# `intersperse`, so a body that emitted one separator too few, or too many, or
# that dropped the second element, is caught here even when the step law above
# is satisfied. The one-element case is why the count needs its own pair of
# defs: the answer there is one element, not two, so the recurrence has to
# branch on whether the tail is empty.
law intersperse_len:
  for xs: List<&2, Nat>
  for sep: Nat
  {P.len(S.intersperse(xs, sep)) == P.ilen(xs) : Nat}
