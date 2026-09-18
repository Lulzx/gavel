import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `len` steps on the cons cell, so both sides reduce to `1n+S.len(xs)`.
def L.len_cons(x, xs):
  {==}

# `x <> Nil{}` is a cons cell, so `len` reduces and both sides are `1n`.
def L.len_single(x):
  {==}

# `append` matches on its first argument, so with a variable `xs` on the left
# the goal does not reduce on its own: this one is inductive, and the induction
# hypothesis rewrites the right-hand side into the left.
def L.len_nil_right(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.len_nil_right(t) : {1n + S.len(P.append(t, Nil{})) == 1n + _ : Nat}
      {==}
