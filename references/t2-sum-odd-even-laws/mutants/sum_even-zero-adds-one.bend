import Base

# `sum_even` adds one at a zero input, where there is nothing to add yet.
#
# This file exists for a law that no generated mutant fails: `sum_even_zero`.
# The law is stated at a literal `0n`, so it is an answer reached by a match
# that has already stopped, and the generator's rules do not rewrite this case
# -- the constant-body mutant copies this body into the other cases, which is
# why it proves `sum_even_zero` and fails `sum_even_succ` and
# `sum_odd_sum_even` instead.
#
# `sum_odd` is the reference, so both of its laws still hold, and
# `sum_even_succ` is definitional at every `k`: `sum_even(1n + k)` unfolds to
# `sum_even(k) + (k + k)` on both sides, whatever `sum_even(0n)` answers.
# `sum_odd_sum_even` does not survive, and cannot: its `0n` case is
# `sum_odd(0n) == sum_even(0n) + 0n`, which is `0n == 1n` for this body. The
# law is still pinned by the other four, and only the ground law names the
# answer `sum_even` gives at `0n` itself.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `sum_even_zero` and `sum_odd_sum_even`.
def sum_odd(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++k:
      sum_odd(k) + (k + k + 1n)

def sum_even(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n++k:
      sum_even(k) + (k + k)
