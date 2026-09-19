import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is a literal `Nil{}`, which is the first case of the outer match.
def L.chunk_two_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes
# the cons case and the inner match takes its empty case.
def L.chunk_two_single(x):
  {==}

# Both matches step on cons cells, so both sides are the first two elements
# grouped in front of the groups of the tail after the second one.
def L.chunk_two_cons(x, y, t):
  {==}

# The match steps on `Nil{}`, so both sides are `Nil{}`.
def L.join_two_nil():
  {==}

# `join_two` steps on the cons cell and writes both halves out, so both sides
# are the same term.
def L.join_two_cons(a, b, t):
  {==}

# Inductive in `ps`. The step: `join_two` writes the head record out and
# `chunk_two` groups it straight back, leaving the heading pair in front of the
# round trip of the tail, which is the hypothesis.
def L.chunk_two_join_two(ps):
  match ps:
    case Nil{}:
      {==}
    case P.MkPair{a, b} <> t:
      %L.chunk_two_join_two(t) :
          {P.MkPair{a, b} <> S.chunk_two(S.join_two(t)) == P.MkPair{a, b} <> _ : List<&2, P.Pair>}
      {==}
