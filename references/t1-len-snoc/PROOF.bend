import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `x <> Nil{}` is a cons cell, so `len` reduces on it and both sides are `1n`.
def L.len_single(x):
  {==}

# `snoc` matches on its first argument, so with a variable `xs` on the left the
# goal does not reduce on its own: this one is inductive, and the induction
# hypothesis rewrites the right-hand side into the left.
def L.len_snoc(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.len_snoc(t, x) : {1n + S.len(S.snoc(t, x)) == 1n + _ : Nat}
      {==}
