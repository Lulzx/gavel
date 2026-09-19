import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `fib_go_zero`. With no numbers left to emit the walk
# answers the empty list, whatever pair is in hand; this body answers the first
# half of the pair, in a cell -- the reading a policy that emits before it has
# looked at the count has. It is otherwise the reference. The step law is stated
# at `1n + k` and never reaches this input, and `fib_list` reaches it only at
# `fib_list(0n)`, which the law `fib_list_zero` covers with its own answer, so
# the length law is the only other one that sees it. The generator cannot reach
# this answer: its rewrites change what a step passes on, and this is the branch a
# step never reaches.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i3.json check
# t2-fib-list --solution <this file> --proof references/t2-fib-list/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["fib_list_zero",
# "fib_go_zero", "fib_go_len", "fib_list_three"]`, and the checker's own words at
# the closed law are `expected : [0n, 1n, 1n, 2n]` against `observed :
# [0n, 1n, 1n]` -- the walk emits one number it was not asked for.
def fib_go(k: Nat, +a: Nat, +b: Nat) -> List<&2, Nat>:
  match k:
    case 0n:
      a <> Nil{}
    case 1n+kp:
      a <> fib_go(kp, b, a + b)

def fib_list(n: Nat) -> List<&2, Nat>:
  fib_go(n, 0n, 1n)
