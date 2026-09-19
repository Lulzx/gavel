import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the match in `second_max` takes its empty
# case and both sides are zero.
def L.second_max_nil():
  {==}

# `h <> t` is a cons cell, so the outer match takes its cons case and hands the
# tail, the head and `0n` to the walk.
def L.second_max_cons(h, t):
  {==}

# The walk's empty case is its second running value.
def L.sec_go_nil(top, second):
  {==}

# The walk's cons case folds the head into both running values and recurses.
def L.sec_go_cons(h, t, top, second):
  {==}

# Both sides are closed, so both matches reduce: the walk starts at `3n` with
# `0n` in the second slot, folds `1n` and `2n` in turn, and reaches its empty
# case with `2n` there. What is left is `2n` against `2n`.
def L.second_max_three():
  {==}
