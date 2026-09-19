import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The second argument is the literal `0n`, which is the arm the walk stops at,
# so the left side is `0n` on the nose.
def L.cd_go_zero(n):
  {==}

# `1n + k` is a successor, so the match takes its step arm: both sides are `k`'s
# own contribution added to the walk below it.
def L.cd_go_step(n, k):
  {==}

# `count_divisors` has no match of its own, so it unfolds to the walk started at
# `n` whatever `n` is.
def L.count_divisors_handoff(n):
  {==}

# Both sides are numerals, so the checker computes the walk.
def L.count_divisors_one():
  {==}

# Both sides are numerals, so the checker computes the walk.
def L.count_divisors_seven():
  {==}

# Both sides are numerals, so the checker computes the walk.
def L.count_divisors_twelve():
  {==}
