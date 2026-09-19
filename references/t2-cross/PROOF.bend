import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.append` has no right-identity lemma in the prelude or in `Base`, and the
# product of a one-row list is that row with nothing appended to it. This is the
# missing lemma: concatenating nothing on the right changes nothing. The
# induction is on the first argument, which is the argument `P.append` matches
# on, so the step is the cons case.
def Policy.append_nil(ps: List<&2, P.Pair>) -> {P.append(ps, Nil{}) == ps : List<&2, P.Pair>}:
  match ps:
    case Nil{}:
      {==}
    case +h <> t:
      %Policy.append_nil(t) : {h <> P.append(t, Nil{}) == h <> _ : List<&2, P.Pair>}
      {==}

# The empty list of `xs` is the first case, and it answers `Nil{}` without
# looking at `ys`.
def L.cross_nil(ys):
  {==}

# The empty list of `ys` is the row's first case, and it answers `Nil{}` without
# looking at `x`.
def L.row_nil(x):
  {==}

# The row's cons case: the front of `ys` is paired with `x` and put in front of
# the row for the tail. Both sides are the same cell in front of the same call.
def L.row_cons(x, y, t):
  {==}

# The product's cons case: the row for the front element is concatenated with
# the product of the tail. Both sides are the same call in the same order.
def L.cross_cons(x, t, ys):
  {==}

# A one-row product is that row, and the row is not a list `P.append` can look
# inside: `ys` is a variable, so the walk is stuck behind the row's own
# recursion and the left side is `P.append(S.row(x, ys), Nil{})` with all of it
# a variable. The right-identity lemma turns that into the bare row, which is
# what the right side already is.
def L.cross_one(x, ys):
  %Policy.append_nil(S.row(x, ys)) : {P.append(S.row(x, ys), Nil{}) == _ : List<&2, P.Pair>}
  {==}

# Both sides are closed, so every match steps and every recursion terminates:
# the product is read off cell by cell, and the two sides agree cell for cell.
def L.cross_two_two():
  {==}
