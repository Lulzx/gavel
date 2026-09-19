import Base
import ./prelude.bend as P

# `sum_fib` adds one at a zero input, where there is nothing to add.
#
# This file exists for a law that no other mutant in the corpus fails:
# `sum_fib_zero`. The law is stated at a literal `0n`, so it is an answer
# reached by a match that has already stopped, and the generator's rules do not
# rewrite this case -- the constant-body mutant copies this body into the other
# cases, which is why it proves `sum_fib_zero` and fails `sum_fib_succ` and
# `sum_fib_pair` instead.
#
# `fib_pair` is the reference, so `fib_pair_zero` and `fib_pair_succ` still
# hold, and `sum_fib_succ` is definitional at every `k`: `sum_fib(1n + k)`
# unfolds to `P.fst(fib_pair(k)) + sum_fib(k)` on both sides, whatever
# `sum_fib(0n)` answers. The induction in `sum_fib_pair` carries no wrong
# answer into any step -- its step only ever calls `sum_fib` at `k`, and its
# rewrites are structural -- but its `0n` case is the one place that names
# `sum_fib(0n)` directly, so that case alone stops converting too. The total
# `sum_fib` should carry at `0n` is `0n`, not `1n`.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `sum_fib_zero` and `sum_fib_pair`.
def fib_pair(n: Nat) -> P.Pair:
  match n:
    case 0n:
      P.MkPair{0n, 1n}
    case 1n++k:
      P.advance(fib_pair(k))

def sum_fib(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n++k:
      P.fst(fib_pair(k)) + sum_fib(k)
