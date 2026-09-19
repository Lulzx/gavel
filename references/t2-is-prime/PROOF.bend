import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The second argument is the literal `0n`, the arm the walk stops at.
def L.no_divisor_zero(n):
  {==}

# `1n` is a successor whose predecessor is `0n`, the other stop.
def L.no_divisor_one(n):
  {==}

# `2n + j` unfolds to `1n + (1n + j)`, so the outer match hands `1n + j` to the
# inner one, whose predecessor is `j`: both sides are the test of `k` added to
# the walk below it.
def L.no_divisor_step(n, j):
  {==}

# `2n + n` unfolds to the successor arm, whose inner match on `1n + n` takes the
# non-trivial arm; `is_prime` has no other match on the way there.
def L.is_prime_handoff(n):
  {==}

# Both sides are values, so the gate is what decides.
def L.is_prime_zero():
  {==}

# Both sides are values, so the gate is what decides.
def L.is_prime_one():
  {==}

# The walk's only candidate is `1n`, the stop, so the answer is `True{}`.
def L.is_prime_two():
  {==}

# `4n` reaches `2n`, the first candidate that divides it.
def L.is_prime_four():
  {==}

# Numerals on both sides, so the checker computes the walk out.
def L.is_prime_seven():
  {==}

# Numerals on both sides, so the checker computes the walk out.
def L.is_prime_nine():
  {==}
