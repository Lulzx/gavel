import Base
import ./prelude.bend as P

# Hand-written, for `positions_nil`, whose left-hand side is the only one in
# this law set that is ground: the list is the literal `Nil{}` and the match
# inside `positions` has already stopped there. The generator rewrites a *step*,
# and an empty case is an answer reached after the match has stopped, so no
# generated rule reaches it.
#
# The change is that one case: the empty list answers a one-element list
# recording position `0n` instead of `Nil{}`. The cons case is the reference's.
#
# Measured 2026-09-19 against the four-law set: **tier 3, two laws unproven --
# `positions_nil`, which this file is for, and `positions_miss`**, whose empty
# case is the answer this body changed as well. `positions_step` and
# `positions_hit` proven. Bare, with no proof, it type-checks, so the failure is
# a law's and not the checker's.
def positions(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> +t:
      P.at_if(P.eq(h, x), 0n <> P.inc_all(positions(x, t)), P.inc_all(positions(x, t)))
