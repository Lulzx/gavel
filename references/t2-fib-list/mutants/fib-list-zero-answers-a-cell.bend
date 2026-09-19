import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `fib_list_zero`. The first zero numbers are none, so the
# answer is the empty list; this body answers a single cell holding `0n` -- the
# reading a policy that emits the first number before it has counted anything
# has. It is otherwise the reference: the successor case hands the same pair to
# the same walk, so the step law and the closed law are untouched, and the only
# law that reaches `0n` through `fib_list` is the one this body is here to guard.
# The generator cannot reach this answer at all -- its rewrites change what a step
# passes on, and this is the branch the walk's own `0n` case never reaches,
# because the reference has no match here for it to rewrite.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-fib-list --solution <this file> --proof references/t2-fib-list/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["fib_list_zero"]`, and the
# checker's own words are `expected : [0n]` against `observed : []` -- the one law
# this body is here to guard.
def fib_go(k: Nat, +a: Nat, +b: Nat) -> List<&2, Nat>:
  match k:
    case 0n:
      Nil{}
    case 1n+kp:
      a <> fib_go(kp, b, a + b)

def fib_list(n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      0n <> Nil{}
    case 1n+np:
      fib_go(1n + np, 0n, 1n)
