import Base
import ./prelude.bend as P

# `min_first` answers a two-element list on a one-element input.
#
# This file exists for the one-element case, which no generated mutant
# distinguishes: the reference reaches it through `P.mf_put`'s empty branch
# rather than through a match of its own, so a rule that rewrites a step never
# touches it. The body special-cases the singleton and answers it twice, which
# keeps the empty branch and the recursive step exactly as they were.
#
# The outer pattern carries `+h` because the head is consumed twice on the
# singleton branch and once on the other; without the marker the checker
# rejects the body outright (tier 1) and the file is evidence of nothing.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `min_first_single`, `min_first_cons`, `min_first_keep`, `min_first_swap`,
# `min_first_len`; `min_first_nil` is the one law it still proves. The cons and
# length laws go with it because the cons case is no longer the tail's answer
# under `P.mf_put`, and the two order laws are stated on a two-element list
# that this body still handles through that same changed step.
def min_first(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          h <> h <> Nil{}
        case h2 <> t2:
          P.mf_put(h, min_first(t))
