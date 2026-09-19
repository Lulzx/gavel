import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The width is the literal `0n`, so the match takes its empty case and both
# sides are zero.
def L.digit_sum_no_fuel(n):
  {==}

# The width is `1n + w`, which the match steps into its successor case with `p`
# bound to `w`: the two sides are then the same digit plus the same walk on the
# number divided by ten.
def L.digit_sum_step(w, n):
  {==}

# Both sides are closed, so the walk computes: the low digit of `123n` is `3n`,
# then `2n`, then `1n`, and the last unit of width finds `0n` left and adds
# nothing. What is left is `6n` against `6n`.
def L.digit_sum_123():
  {==}

# The same computation on a number with zeros in the middle: `0n`, `0n`, `0n`
# and `1n` come off `1000n` over four units of width, so the sum is `1n`.
def L.digit_sum_thousand():
  {==}


