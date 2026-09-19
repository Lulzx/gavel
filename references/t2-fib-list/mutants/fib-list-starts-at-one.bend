import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `fib_list_three`, and with it `fib_list_succ`. The
# sequence starts at `0n` with `1n` after it; this body starts the walk from the
# pair `(1n, 1n)`, which is the other common way to write the sequence and emits
# `[1n, 1n, 2n, 3n, 5n, ...]`. It is otherwise the reference, and the walk itself
# is untouched, so the laws about the walk all hold and the two laws that pin the
# pair the sequence starts from are the ones this body is here to guard. The
# generator cannot reach this answer: it rewrites what a step passes on, and the
# pair `fib_list` seeds is not part of any step.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-fib-list --solution <this file> --proof references/t2-fib-list/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["fib_list_succ",
# "fib_list_three"]`, and the checker's own words at the closed law are
# `expected : [1n, 1n, 2n]` against `observed : [0n, 1n, 1n]` -- the sequence it
# emits starts one number along.
def fib_go(k: Nat, +a: Nat, +b: Nat) -> List<&2, Nat>:
  match k:
    case 0n:
      Nil{}
    case 1n+kp:
      a <> fib_go(kp, b, a + b)

def fib_list(n: Nat) -> List<&2, Nat>:
  fib_go(n, 1n, 1n)
