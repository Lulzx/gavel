import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The budget is the literal `0n`, so the outer match takes its empty case and
# both sides are zero.
def L.collatz_len_no_fuel(n):
  {==}

# The number is the literal `0n` and the budget is a variable, so the proof is a
# case split on the budget: zero spends the outer match's empty case, and a
# successor reaches the inner match, whose empty case answers `0n` too.
def L.collatz_len_zero(f):
  match f:
    case 0n:
      {==}
    case 1n+fp:
      {==}

# The same split, with the number at `1n`: the inner match's second case, the
# one that is `1n+0n`, answers `0n` without recursing.
def L.collatz_len_one(f):
  match f:
    case 0n:
      {==}
    case 1n+fp:
      {==}

# The number is `1n + 1n + p`, which the inner match steps into its third case
# with, and the budget is `1n + f`, which the outer match steps into its
# successor case with. Both sides are then the same `1n +` in front of the same
# walk: the step term is carried unchanged, because on a variable the parity
# test and the halving are stuck and the pick does not resolve.
def L.collatz_len_step(f, p):
  {==}

# Both sides are closed, so the whole walk computes: `30n` of budget is enough
# for the eight steps that take `6n` to `1n` -- `6n`, `3n`, `10n`, `5n`, `16n`,
# `8n`, `4n`, `2n`, `1n` -- and what is left is `8n` against `8n`.
def L.collatz_len_six():
  {==}

# The same computation over a longer closed walk: `15n` climbs to `160n` before
# it comes down, and reaches `1n` after `17n` steps, all of which `30n` of
# budget pays for. Every value on the way is closed, so the parity test, the
# halving and the `3n*n + 1n` branch all reduce. Kept short on purpose: a
# hundred-step walk reads the same here and costs V4 a multiple of the budget.
def L.collatz_len_fifteen():
  {==}
