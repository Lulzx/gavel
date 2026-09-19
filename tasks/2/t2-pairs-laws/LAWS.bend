import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no neighbours to pack. Both sides compute, so this one
# is definitional, and it is a pin: it fixes the answer on the empty input,
# which neither of the two laws below reaches.
law pairs_nil:
  {S.pairs(Nil{}) == Nil{} : List<&2, P.Pair>}

# LAW: neither has a one-element list. Both sides compute, so this is
# definitional too. The step law below constrains only lists of two or more
# elements -- it names `a <> (b <> t)` -- so without this one a body that
# answered a half pair here would satisfy it, and without the step law this one
# would say nothing about any longer list: the odd tail is what a body that
# packs the last element with nothing gets wrong.
law pairs_single:
  for x: Nat
  {S.pairs(x <> Nil{}) == Nil{} : List<&2, P.Pair>}

# LAW: the step. Two elements or more answer the first two packed together, in
# front of the pairs of everything from the *second* one on. Both sides compute,
# so this is definitional, and it is the law that says which numbers go where: a
# body that recursed on `t` instead of on `b <> t` answers a shorter list here
# and leaves the two sides unconvertible, and a body that swapped the two
# components of the pair is caught here and nowhere else, since no other law
# looks inside a pair.
law pairs_cons:
  for a: Nat
  for b: Nat
  for t: List<Nat>
  {S.pairs(a <> (b <> t)) == P.MkPair{a, b} <> S.pairs(b <> t) : List<&2, P.Pair>}

# LAW: a list of `n` elements answers `n - 1` pairs -- the first element is the
# one that has nothing on its left to be packed with, and a lone last element is
# dropped. This is the law that is not definitional: `pairs` is stuck on a
# variable `x` on the front, so with a variable `xs` the two sides do not
# compute, and the induction is the proof. It is the count half of the step
# above, which is about which numbers come out; this one is about how many
# pairs there are.
law pairs_len:
  for xs: List<Nat>
  for x: Nat
  {P.plen(S.pairs(x <> xs)) == P.len(xs) : Nat}
