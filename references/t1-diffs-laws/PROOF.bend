import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is a literal `Nil{}`, which is the first case of the outer match.
def L.diffs_nil():
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes the
# cons case and the inner match takes its empty case.
def L.diffs_single(x):
  {==}

# The outer match takes the cons case and the inner match sees the cons tail, so
# both sides reduce to the difference of the two heads in front of the
# differences of the tail from the second head on.
def L.diffs_cons(a, b, t):
  {==}

# Inductive in `xs`. The step case leaves `1n + S.len(S.diffs(h <> t))` against
# `1n + P.len(t)`: the length of the first difference in front of the tail's
# differences is one plus the length of those differences, and the hypothesis
# at the tail is exactly the term sitting there.
def L.diffs_len(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.diffs_len(t, h) : {1n + P.len(S.diffs(h <> t)) == 1n + _ : Nat}
      {==}
