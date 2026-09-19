import Base
import ./prelude.bend as P
import ./solution.bend as S

# The three laws fix one branch each. `klo` is `P.le(x, lo)` and `khi` is
# `P.le(hi, x)`, taken by whoever calls `clamp`; each law hands a branch's
# decision in as a literal, so both sides are the same term after the match
# takes its case and there is no induction and no rewriting anywhere below.

# LAW: a value at or below the lower bound answers the lower bound. The first
# test is a literal `True{}`, so the second decision never matters -- that is
# what `khi` being universally quantified says, and the law needs no premise
# about it.
law clamp_below:
  for +x: Nat
  for +lo: Nat
  for +hi: Nat
  for khi: Bool
  {S.clamp(x, lo, hi, True{}, khi) == lo : Nat}

# LAW: a value above the range answers the upper bound. Both decisions are
# literals here: the first test failed, so the second test is reached, and it
# passed.
law clamp_above:
  for +x: Nat
  for +lo: Nat
  for +hi: Nat
  {S.clamp(x, lo, hi, False{}, True{}) == hi : Nat}

# LAW: a value inside the range is its own answer. Both tests failed. This is
# the law that stops a body answering a bound on the branch that should have
# returned the value.
law clamp_inside:
  for +x: Nat
  for +lo: Nat
  for +hi: Nat
  {S.clamp(x, lo, hi, False{}, False{}) == x : Nat}
