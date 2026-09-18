import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `append` matches on its first argument, so with a variable `xs` on the left
# the goal does not reduce on its own: this one is inductive, and the induction
# hypothesis rewrites the right-hand side into the left.
def L.append_nil(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.append_nil(t) : {h <> S.append(t, Nil{}) == h <> _ : List<Nat>}
      {==}

# The first argument here is the literal `Nil{}`, so `append` reduces on it and
# the goal is `ys == ys`.
def L.append_nil_left(ys):
  {==}

# `append` steps on the cons cell, so both sides are `x <> S.append(xs, ys)`.
def L.append_cons(x, xs, ys):
  {==}
