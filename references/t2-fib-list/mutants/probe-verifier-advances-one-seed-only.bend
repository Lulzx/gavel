import Base
import ./prelude.bend as P

# PROBE. An independently invented body that reads "each number is the sum of the
# two before it" as a slide of one component: it emits the number in hand and
# advances only the first half of the pair, so the second half stands still and
# the sequence reads `[0n, 1n, 2n, 3n, ...]` -- each number the runner-up plus the
# number before it, which is a plausible mis-remembering of the recurrence. It is
# wrong at the third number: the closed law asks for `[0n, 1n, 1n]` and this body
# answers `[0n, 1n, 2n]`. A reading of the laws that pays this body is a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-fib-list --solution <this file> --proof references/t2-fib-list/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["fib_go_succ",
# "fib_go_len", "fib_list_three"]`, and the checker's own words at the closed law
# are `expected : [0n, 1n, 2n]` against `observed : [0n, 1n, 1n]` -- the third
# number is the sum of the wrong pair.
def fib_go(k: Nat, +a: Nat, +b: Nat) -> List<&2, Nat>:
  match k:
    case 0n:
      Nil{}
    case 1n+kp:
      a <> fib_go(kp, a + b, b)

def fib_list(n: Nat) -> List<&2, Nat>:
  fib_go(n, 0n, 1n)
