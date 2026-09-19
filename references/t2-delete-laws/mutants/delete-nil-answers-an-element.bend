import Base
import ./prelude.bend as P

# Hand-written, for `delete_nil`, whose left-hand side is the only one in this
# law set that is ground: the list is the literal `Nil{}` and the match inside
# `delete` has already stopped there. The generator rewrites a *step*, and an
# empty case is an answer reached after the match has stopped, so no generated
# rule reaches it -- the corpus above fails `delete_step` and nothing else at
# the empty list.
#
# The change is that one case: the empty list answers a one-element list holding
# the target instead of `Nil{}`. It keeps the cons case identical to the
# reference.
#
# Measured 2026-09-19 against the four-law set: **tier 3, two laws unproven --
# `delete_nil`, which this file is for, and `delete_miss`**, whose empty case is
# the answer this body changed as well. `delete_step` and `delete_hit` proven.
# Bare, with no proof, it type-checks -- so the failure is a law's and not the
# checker's.
def delete(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case +h <> +t:
      P.at_if(P.eq(h, x), t, h <> delete(x, t))
