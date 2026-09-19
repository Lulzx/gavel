import Base
import ./prelude.bend as P

# The cons arm answers `1n` instead of recursing, so every non-empty list has
# length one.
#
# This file exists for `len_cons`, which no other mutant in the corpus fails.
# The law is `len(x <> xs) == 1n + len(xs)`, and its left-hand side is a cons
# cell before `len` ever looks at it -- so the `Nil{}` arm is not on the path,
# and a body that gets the *base case* wrong (`len-base-one.bend`) shows up in
# `len_single` and leaves `len_cons` alone. The cons step itself was the part
# of `len` no generated rule was reaching: a mutation that rewrites a step has
# to rewrite something the law's own left-hand side unfolds.
#
# A body that drops the recursion is wrong in a way the other three laws cannot
# see. `len_single(x)` is `len(x <> Nil{}) == 1n` and this answers `1n`;
# `len_map` is `len(map(xs)) == len(xs)`, and read naively it survives -- both
# sides are `1n` for a non-empty `xs` and `0n` at `Nil{}`. The measurement says
# otherwise, which is worth recording rather than explaining away: the law is
# unproven against this body even though every closed instance of it is true.
# `map_cons` does not mention `len`. Bare, with no proof: tier 2.
#
# Measured 2026-09-19 against the four-law set: tier 3, two laws unproven --
# `len_cons`, which this file is for, and `len_map`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.inc(h) <> map(t)
