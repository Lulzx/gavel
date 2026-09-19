import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The first argument is the literal `0n`, the outer match's empty arm.
def L.lcm_zero_left(m):
  {==}

# `n` is a variable, so the outer match is stuck and the law needs the
# induction. At zero the outer match takes its empty case. At `1n + p` it steps
# to the successor case and the inner match reads the literal `0n`, its own
# empty case; both land on `0n` without recursing, so neither arm calls the
# hypothesis.
def L.lcm_zero_right(n):
  match n:
    case 0n:
      {==}
    case 1n+np:
      {==}

# Both arguments are successors, so the outer match steps and the inner match
# steps, and both sides are the walk started at `n` with `m` candidates.
def L.lcm_handoff(n, m):
  {==}

# The budget is the literal `0n`, the walk's stopped arm, and both sides are the
# candidate it was carrying.
def L.lcm_go_no_fuel(c, step, m):
  {==}

# The budget is `1n + f`, so the walk steps: both sides are the divisibility
# test of the candidate against `m`, and the walk below it on the next multiple
# of `step`.
def L.lcm_go_step(f, c, step, m):
  {==}

# Numerals on both sides, so the checker walks the candidates out.
def L.lcm_one_one():
  {==}

# Numerals on both sides, so the checker walks the candidates out.
def L.lcm_four_six():
  {==}

# Numerals on both sides, so the checker walks the candidates out.
def L.lcm_six_four():
  {==}

# Numerals on both sides, so the checker walks the candidates out.
def L.lcm_seven_three():
  {==}

# Numerals on both sides, so the checker walks the candidates out -- and this is
# the one that spends the budget exactly, so it is the one that computes all the
# way to the stopped arm's edge.
def L.lcm_five_seven():
  {==}
