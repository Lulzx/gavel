import Base
import ./prelude.bend as P

# The empty list is not a palindrome.
#
# `is_pal_nil()` is `is_pal(Nil{}) == True{}`, and no other mutant in this
# corpus fails it. The solution for this task is a single call --
# `P.eq_list(xs, P.rev(xs))` -- so there is no step to rewrite and no recursion
# argument to redirect, and `tools/mutate.py` has nothing to reach for. That is
# the whole reason the law was carrying no evidence: three of the four laws in
# this set are answered by the body, and this one is answered by the empty case
# of `P.eq_list`, which the solution never names.
#
# The law is load-bearing rather than decorative: it is the base case the other
# three are pinned against, and the body above makes it false. The match is on
# the reusable `+xs`, so the cons arm still spends `xs` on the reference call
# exactly as the solution does. Bare, with no proof: tier 2.
#
# Measured 2026-09-19 against the four-law set: tier 3, two laws unproven --
# `is_pal_nil`, which this file is for, and `is_pal_rev`, whose proof rewrites
# the reference call at `Nil{}` and finds the answer has changed underneath it.
def is_pal(+xs: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      P.eq_list(xs, P.rev(xs))
