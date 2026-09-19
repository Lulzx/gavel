import Base
import ./prelude.bend as P

# `divmod3` answers a quotient of one on a zero input.
#
# This file exists for a law that no other mutant in the corpus fails: the
# empty case. `divmod3_zero` is stated at a literal `0n`, so it is an answer
# reached by a match that has already stopped, and the generator's rules
# rewrite a *step* -- every one of the five it produced leaves this case alone
# (the constant-body mutant copies this very body into the other cases, which
# is why it proves `divmod3_zero` and fails the other four).
#
# It is the reference with that one case given a non-zero quotient, so it
# type-checks and every recursive step is untouched. The quotient goes up by
# one somewhere it should not, which nothing but the ground law can see: the
# three other pins are at `1n` and `2n`, and the step law is stated at `3n + k`
# and only ever compares against what `divmod3` answers at `k`.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `divmod3_zero`.
def divmod3(n: Nat) -> P.Pair:
  match n:
    case 0n:
      P.MkPair{1n, 0n}
    case 1n:
      P.MkPair{0n, 1n}
    case 2n:
      P.MkPair{0n, 2n}
    case 3n++k:
      P.shift(divmod3(k))
