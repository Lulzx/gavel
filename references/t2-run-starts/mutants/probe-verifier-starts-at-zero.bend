import Base
import ./prelude.bend as P

# PROBE. The plausible wrong answer: a body that hands the whole list to the
# walk with `0n` as both the element before it and the position to start at,
# instead of opening the first run itself. It is the reading a policy that
# noticed the walk already knows how to compare a head with the value before it
# would write -- the special case for the first element looks like duplication.
# It is wrong exactly when the first element is `0n`: the walk then finds
# `same(0n, 0n)` and passes position `0n` over, so the run that must open at
# `0n` is dropped. Read the verdict: **tier 3** means the law set catches it;
# tier 4 means the task pays full reward for it and the law set has a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-run-starts --solution <this file> --proof
# references/t2-run-starts/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["run_starts_single"]`. No hole, and one law is the point: only
# `run_starts_single` applies the answer to a list whose *first element* is a
# variable, so it is the only law that reaches the case this body gets wrong,
# and `run_starts_three` does not -- `[1n, 1n, 2n]` starts with `1n`, which the
# walk already distinguishes from the seed `0n`.
def run_starts_go(rest: List<&2, Nat>, prev: Nat, +i: Nat) -> List<&2, Nat>:
  match rest:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.put_start(i, run_starts_go(t, h, Nat.add(i, 1n)), P.same(h, prev))

def run_starts(xs: List<&2, Nat>) -> List<&2, Nat>:
  run_starts_go(xs, 0n, 0n)
