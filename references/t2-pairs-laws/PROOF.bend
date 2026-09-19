import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is a literal `Nil{}`, which is the first case of the outer match.
def L.pairs_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes the
# cons case and the inner match takes its empty case.
def L.pairs_single(x):
  {==}

# The outer match takes the cons case and the inner match sees the cons tail, so
# both sides reduce to the first two elements packed together in front of the
# pairs of the tail from the second element on.
def L.pairs_cons(a, b, t):
  {==}

# Inductive in `xs`. The step case leaves `1n + P.plen(S.pairs(h <> t))` against
# `1n + P.len(t)`: a pair on the front of the answer is one more pair, and the
# hypothesis at the tail is exactly the term sitting inside `plen`.
def L.pairs_len(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.pairs_len(t, h) : {1n + P.plen(S.pairs(h <> t)) == 1n + _ : Nat}
      {==}
