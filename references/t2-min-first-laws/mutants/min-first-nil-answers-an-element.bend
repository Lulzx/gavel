import Base
import ./prelude.bend as P

# `min_first` answers a one-element list on the empty input.
#
# This file exists for a law no generated mutant fails: every rule in
# `tools/mutate.py` rewrites a step, and the empty case is an answer the walk
# has already stopped at. It is the reference with the `Nil{}` branch given a
# non-empty answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `min_first_nil`, `min_first_single`, `min_first_keep`, `min_first_swap` and
# `min_first_len`; `min_first_cons` alone still checks. The empty answer is
# reachable from every other law here -- `min_first(x <> Nil{})` is
# `P.mf_put(x, min_first(Nil{}))`, and the length induction's base reduces
# `P.len(min_first(Nil{}))` -- so the one change takes the whole set with it.
def min_first(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      P.mf_put(h, min_first(t))
