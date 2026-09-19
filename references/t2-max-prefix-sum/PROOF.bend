import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the walk in `max_prefix_sum` takes its empty
# case and both sides are zero.
def L.max_prefix_sum_nil():
  {==}

# The list is a variable, so the wrapper's body is the same term whatever the
# shape: the induction steps on the list, and the two sides unfold to the same
# walk at each case -- the empty list against the walk's empty case, and a cons
# cell against the walk started at zero.
def L.max_prefix_sum_walk(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      {==}

# The walk's empty case is its best running value.
def L.mpg_nil(acc, best):
  {==}

# The walk's cons case adds the head to the running sum, keeps the larger of the
# new sum and the best, and recurses on the tail: the two sides are the same
# term.
def L.mpg_cons(h, t, acc, best):
  {==}

# Both sides are closed, so both matches reduce: the walk starts at `0n` with
# `0n` in the best slot, folds `3n`, `1n` and `2n` in turn, and reaches its
# empty case with `6n` there. What is left is `6n` against `6n`.
def L.max_prefix_sum_three():
  {==}
