import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `zip_sum` steps on its first list, so with `Nil{}` there the first branch is
# taken no matter what the second list is: both sides are `Nil{}` by unfolding
# alone.
def L.zip_sum_nil_left(ys):
  {==}

# With a variable first list the outer match is stuck, so the induction is on
# `xs`. The cons case unfolds the outer step and the inner match on the literal
# `Nil{}`, which picks the empty answer on both sides.
def L.zip_sum_nil_right(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      {==}

# `len` folds over `zip_sum` and `min` steps through both of its arguments, so
# the hypothesis at `(t1, t2)` -- the single live use of either tail -- leaves
# `1n + P.min(P.len(t1), P.len(t2))` on both sides: the left is exactly that
# after the rewrite, and the right is `min`'s own step through two successors.
def L.zip_sum_len(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h1 <> t1:
      match ys:
        case Nil{}:
          {==}
        case h2 <> t2:
          %Equal.sym(Nat, P.len(S.zip_sum(t1, t2)), P.min(P.len(t1), P.len(t2)), L.zip_sum_len(t1, t2)) : {1n + _ == P.min(P.len(h1 <> t1), P.len(h2 <> t2)) : Nat}
          {==}

# Zipping a list with itself doubles every element. The step unfolds both
# matches, which expose the same head on either side, and the hypothesis at
# `(t, t)` is the only live mention of `t`.
def L.zip_sum_self(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<Nat>, S.zip_sum(t, t), P.double_all(t), L.zip_sum_self(t)) : {(h + h) <> _ == (h + h) <> P.double_all(t) : List<Nat>}
      {==}

# Both matches unfold to a cons over the same heads, so the two sides are the
# same term.
def L.zip_sum_cons(h1, t1, h2, t2):
  {==}
