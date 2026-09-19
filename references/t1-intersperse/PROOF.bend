import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The input is the literal `Nil{}`, which is the first case of the outer match.
def L.intersperse_nil(sep):
  {==}

# `x <> Nil{}` is a cons cell whose tail is `Nil{}`, so the outer match takes the
# cons case and the inner match takes its empty case.
def L.intersperse_single(x, sep):
  {==}

# The outer match takes the cons case and the inner match sees the cons tail, so
# both sides reduce to the head, the separator and the recursive call.
def L.intersperse_cons(a, b, t, sep):
  {==}

# The one law that needs an induction. `xs` is a variable, so `intersperse` is
# stuck and `{==}` gets nowhere; the match is on `xs`, and inside the cons case a
# second match on the tail, because the answer's length is one element plus
# `ilen_tail` of the tail and `ilen_tail` has its own two cases.
#
#   `Nil{}`: both sides are `0n`.
#   `h <> Nil{}`: the inner match takes its empty case, so the left is `len` of a
#     one-element list and the right is `1n + ilen_tail(Nil{})`; both are `1n`.
#   `h <> (h2 <> t2)`: `len` steps the cons off, leaving two plus the length of
#     the recursive call, and the hypothesis -- whose subject is the smaller list
#     `h2 <> t2` -- turns that into two plus `ilen(h2 <> t2)`, which is the right
#     side unfolded.
def L.intersperse_len(xs, sep):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      match t:
        case Nil{}:
          {==}
        case h2 <> t2:
          %L.intersperse_len(h2 <> t2, sep) : {2n + P.len(S.intersperse(h2 <> t2, sep)) == 2n + _ : Nat}
          {==}
