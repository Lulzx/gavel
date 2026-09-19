import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a list has no common prefix with nothing at all -- the empty list on the
# left ends the walk before the other side is looked at. Both sides compute, so
# this one is definitional, and it is the left half of the anchor.
law lcp_len_nil_left:
  for ys: List<&2, Nat>
  {S.lcp_len(Nil{}, ys) == 0n : Nat}

# LAW: the same, with the empty list on the right. It is not the same law: the
# walk looks at the left list first, so this one is the branch that says the
# right list running out ends the walk too. The left list is a variable here, so
# the two sides do not reduce by themselves -- the law is inductive in `xs` --
# and a body that kept counting after one side ran out fails it.
law lcp_len_nil_right:
  for xs: List<&2, Nat>
  {S.lcp_len(xs, Nil{}) == 0n : Nat}

# LAW: two one-element lists with the same element have a common prefix of
# length one. This is the anchor's positive half, written with no variables at
# all: it says that a pair of equal heads is counted rather than skipped, which
# no law about the empty list can say. Both sides compute.
law lcp_len_equal_singletons:
  {S.lcp_len(1n <> Nil{}, 1n <> Nil{}) == 1n : Nat}

# LAW: the step. A common prefix either starts with two equal heads -- and then
# it is one element longer than the common prefix of the tails -- or it starts
# with two different ones and is empty. The prelude's `P.is_eq` decides which,
# and `P.gate` turns that decision into the length, so this is where the
# comparison is stated, and it is the law a body that counted a matching pair
# without checking that the elements agree fails. Both sides compute.
law lcp_len_cons:
  for h: Nat
  for +t: List<&2, Nat>
  for k: Nat
  for +u: List<&2, Nat>
  {S.lcp_len(h <> t, k <> u) == P.gate(P.is_eq(h, k), 1n + S.lcp_len(t, u)) : Nat}

# LAW: the longest common prefix of a list with itself is the whole list. This is
# the law that pins the walk as a *prefix* rather than a comparison of one pair
# of elements: it says every position is counted while the elements agree, so a
# body that stopped early, or that skipped a matching pair, leaves the two sides
# apart. It is inductive in `xs`, and it is the law the step law and the two
# anchors together already imply -- which is what makes it the reading of what
# they say.
law lcp_len_self:
  for +xs: List<&2, Nat>
  {S.lcp_len(xs, xs) == P.len(xs) : Nat}
