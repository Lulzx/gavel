import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is a list constructor, so the match in `extremes` takes its empty case
# and both sides are the empty list.
def L.extremes_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes
# its cons case and the walk is started at the head, twice.
def L.extremes_single(x):
  {==}

# The cons case of `extremes` hands the tail and the head to the walk.
def L.extremes_cons(x, xs):
  {==}

# The walk's empty case is the two running values in front of the empty list.
def L.ext_go_nil(lo, hi):
  {==}

# The walk's cons case folds the head into both running values and recurses.
def L.ext_go_cons(h, t, lo, hi):
  {==}

# Inductive in `xs`. The empty case is `lo <> hi <> Nil{}`, which is two
# elements. The cons case reduces the goal to the walk at the tail with the
# running values the step produced, which is the hypothesis at those values --
# it holds for *every* pair of running values, which is why the law quantifies
# over them rather than stating the one pair `extremes` starts with.
def L.ext_go_len(xs, lo, hi):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      L.ext_go_len(t, P.min2(h, lo), P.max2(h, hi))
