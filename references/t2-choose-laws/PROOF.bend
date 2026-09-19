import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The first argument is the literal `0n`, so the outer match takes its first
# arm, and the second argument is a successor, so the inner match takes its
# second arm and answers `0n`. Nothing is left stuck.
def L.choose_zero_left(k):
  {==}

# Inductive in `n`. The empty case reaches the `1n` arm through the literal
# `0n`; the step reaches it through the successor arm and then the inner match
# on the literal `0n`. Both sides are `1n` in both arms.
def L.choose_zero_right(n):
  match n:
    case 0n:
      {==}
    case 1n++p:
      {==}

# Definitional: the first argument is a successor, so the outer match takes the
# step arm, and the second is a successor, so the inner match takes its second
# arm and calls once with the pair and once with the pair's predecessor.
def L.choose_step(n, k):
  {==}

# Both sides are literals, so the checker computes them.
def L.choose_five_two():
  {==}
