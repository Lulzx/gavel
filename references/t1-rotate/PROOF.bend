import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `n` is the literal `0n`, which is the first case of the match, so both sides
# reduce to `xs`.
def L.rotate_zero(xs):
  {==}

# The first case of the match sees a successor, so the head comes off and the
# recursive call is left on both sides of `{==}` with the same arguments.
def L.rotate_succ(n, x, t):
  {==}

# The one law that needs the induction. `n` is a variable, so `rotate` is stuck
# and `{==}` gets nowhere on its own; the match splits it into the two cases,
# and each one computes -- `0n` falls into the first case of the body, whose
# answer is the list itself, and `1n + p` falls into the successor case, whose
# inner match sees the empty list. Neither case needs the hypothesis.
def L.rotate_nil(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      {==}
