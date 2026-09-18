import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has exactly one prefix, the empty list itself. Both sides
# compute, so this is definitional, and it is the weak half: it fixes where the
# list of prefixes starts, and a body that answered `P.PNil{}` everywhere would
# still satisfy it.
law prefixes_nil:
  {S.prefixes(Nil{}) == P.PCons{Nil{}, P.PNil{}} : P.Prefixes}

# LAW: the step of the enumeration. Both sides compute, so this is definitional
# too, and it is the law that says the missing prefixes are the ones that carry
# the head: the empty list comes first, and everything after it is a prefix of
# the tail with `h` on the front. A body that enumerated the tail's prefixes
# unchanged -- `P.PCons{Nil{}, S.prefixes(t)}` -- agrees with the law below on
# any list whose elements are all zero, and leaves the two sides here
# unconvertible.
law prefixes_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.prefixes(h <> t) == P.PCons{Nil{}, P.cons_all(h, S.prefixes(t))} : P.Prefixes}

# LAW: the number of prefixes of `xs` is one more than the number of elements.
# This is the work. The direct induction does not go through: its step case is
# about `P.llen(P.cons_all(h, S.prefixes(t)))`, and the hypothesis is about
# `P.llen(S.prefixes(t))`, so the auxiliary fact that putting one element on the
# front of every prefix does not change how many there are has to be stated and
# proved first. `xs` is `+` because the tail is live twice in the step, once as
# the recursive call the hypothesis replaces and once in what is left of the
# goal.
law prefixes_len:
  for +xs: List<&2, Nat>
  {P.llen(S.prefixes(xs)) == 1n + P.len(xs) : Nat}
