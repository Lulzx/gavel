import Base
import ./prelude.bend as P

# `del_min` answers a one-element list on the empty input.
#
# This file exists for a law no generated mutant fails: every rule in
# `tools/mutate.py` rewrites a step, and the empty case is an answer the walk has
# already stopped at. It is the reference with the `Nil{}` branch given a
# non-empty answer, so it type-checks and every recursive step is untouched.
def del_min(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case +h <> +t:
      P.dm_put(h, t, del_min(t))
