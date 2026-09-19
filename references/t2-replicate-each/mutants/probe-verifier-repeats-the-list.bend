import Base
import ./prelude.bend as P

# PROBE. An independently invented body that reads "repeat each element `n`
# times" as "repeat the list `n` times": it decides on the count first and
# attaches the whole list once per unit of `n`, so `[1n, 2n]` with `2n` repeats
# reads `[1n, 2n, 1n, 2n]` instead of `[1n, 1n, 2n, 2n]`. It is the reading a
# policy that took `n` for the number of times the *list* appears has, and it is
# a different body rather than a reordered one -- the count chooses the shape
# here, where in the reference the list does. A reading of the laws that pays
# this body is a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-replicate-each --solution <this file> --proof references/t2-replicate-each/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["replicate_each_nil",
# "replicate_each_cons", "replicate_each_two"]`, and the checker's own words at
# the closed law are `expected : [1n, 2n, 1n, 2n]` against `observed :
# [1n, 1n, 2n, 2n]` -- the list repeated, not its elements.
def replicate_each(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+np:
      P.append(xs, replicate_each(xs, np))
