import Base
import ./prelude.bend as P

# `fib_pair` answers the pair *above* a zero input instead of the first pair.
#
# This file exists for a law that no other mutant in the corpus fails:
# `fib_pair_zero`. The law is stated at a literal `0n`, so it is an answer
# reached by a match that has already stopped, and the generator's rules do not
# rewrite this case -- the constant-body mutant copies this body into the other
# cases, which is why it proves `fib_pair_zero` and fails `fib_pair_succ` and
# `sum_fib_pair` instead.
#
# The answer is `MkPair{1n, 1n}`, which is not the first pair. It is the pair at
# `1n` shifted by one, so it is not an arbitrary wrong answer: the second
# element still matches the running total at `0n` (`sum_fib(0n) + 1n` is `1n`,
# and this pair's second element is `1n`), which is what keeps `sum_fib_pair`
# true through the induction -- the step's rewrites are structural in
# `fib_pair`'s recursion and do not look at this answer. `fib_pair_succ` is
# definitional at every `k` including `0n`, since both sides unfold to
# `P.advance(fib_pair(0n))`. Only the ground law names the answer itself, and
# only the first element is wrong: `0n` against `1n`.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `fib_pair_zero`.
def fib_pair(n: Nat) -> P.Pair:
  match n:
    case 0n:
      P.MkPair{1n, 1n}
    case 1n++k:
      P.advance(fib_pair(k))

def sum_fib(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++k:
      P.fst(fib_pair(k)) + sum_fib(k)
