import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The argument is the literal `0n`, so the first arm is the one that is taken
# and both sides are `1n` without anything being matched.
def L.fact_zero():
  {==}

# Definitional: the argument is a successor, so the match takes the step arm,
# binds its predecessor, and the body is the same multiplication of the same
# number by the same recursive call.
def L.fact_succ(n):
  {==}

# Both sides are literals, so the checker computes them.
def L.fact_five():
  {==}
