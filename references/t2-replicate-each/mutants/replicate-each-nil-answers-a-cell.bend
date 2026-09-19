import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `replicate_each_nil`. An empty list has nothing to
# repeat, so the answer is the empty list; this body answers a single cell
# holding `0n` -- the reading a policy that emitted one copy of something before
# it had read anything has. It is otherwise the reference: the cons case is
# untouched, so the step law and the closed law hold, and the only laws that
# reach the empty input are the ones this body is here to guard. The generator
# cannot reach this answer at all -- its rewrites change what a step passes on,
# and this is the branch a step never reaches, because the empty list is where
# the recursion has already stopped.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-replicate-each --solution <this file> --proof references/t2-replicate-each/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["replicate_each_nil",
# "replicate_each_zero", "replicate_each_one", "replicate_each_two"]`, and the
# checker's own words at the closed law are `expected : [1n, 1n, 2n, 2n, 0n]`
# against `observed : [1n, 1n, 2n, 2n]` -- the stray cell follows the answer.
def replicate_each(xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      P.append(P.rep(h, n), replicate_each(t, n))
