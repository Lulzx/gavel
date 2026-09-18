import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `len` steps on the cons cell, so both sides reduce to `1n+S.len(xs)`.
def L.len_cons(x, xs):
  {==}

# `x <> Nil{}` is a cons cell, so `len` reduces on it and both sides are `1n`.
def L.len_single(x):
  {==}

# Inductive in `xs`: the step reduces to a cons cell in front of the two tails,
# and the induction hypothesis matches those tails exactly.
def L.len_map(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.len_map(t) : {1n + S.len(S.map(t)) == 1n + _ : Nat}
      {==}

# `map` steps on the cons cell, so both sides are `P.inc(x) <> S.map(xs)`.
def L.map_cons(x, xs):
  {==}
