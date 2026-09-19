import Base
import ./prelude.bend as P

# TODO(policy): implement. The Fibonacci pair: the first element is the n-th
# Fibonacci number and the second is the one after it. `0n` is the first pair,
# and one more advances the pair below it with `P.advance`, which is why the
# second element of the `0n` pair is `1n` rather than a second `0n`.
def fib_pair(n: Nat) -> P.Pair:
  ?TODO

# TODO(policy): implement. The running total of the Fibonacci numbers below `n`:
# `0n` adds nothing, and one more adds the earlier half of the pair below it to
# the total below it, with `P.fst` naming that half.
def sum_fib(n: Nat) -> Nat:
  ?TODO
