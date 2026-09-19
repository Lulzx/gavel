import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `replicate_each_cons`, and with it `replicate_each_two`.
# The copies of an element come *before* the copies of the rest, so the order of
# the elements is kept; this body attaches them after it instead, so `[1n, 2n]`
# with `2n` repeats reads `[2n, 2n, 1n, 1n]` -- a policy that built the answer
# from the back. It is otherwise the reference, and the empty answer and the
# count are untouched, so the two content laws hold and the laws about the order
# are the ones this body is here to guard. The generator cannot reach this
# answer: its rewrites change what a step passes on, and this changes the order
# the step attaches the two halves in.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-replicate-each --solution <this file> --proof references/t2-replicate-each/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["replicate_each_zero",
# "replicate_each_cons", "replicate_each_one", "replicate_each_two"]`, and the
# checker's own words at the closed law are `expected : [2n, 2n, 1n, 1n]` against
# `observed : [1n, 1n, 2n, 2n]` -- the two halves of the answer in the wrong
# order.
def replicate_each(xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(replicate_each(t, n), P.rep(h, n))
