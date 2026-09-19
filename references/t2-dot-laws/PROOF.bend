import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `dot` steps on its first list, so with `Nil{}` there the first branch is taken
# no matter what the second list is, and both sides are `0n` by unfolding alone.
def L.dot_nil_left(ys):
  {==}

# With a variable first list the outer match is stuck, so the induction is on
# `xs`. The cons case unfolds the outer step and the inner match on the literal
# `Nil{}`, which picks the empty answer on both sides.
def L.dot_nil_right(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      {==}

# Both matches unfold to a cons over the same heads, so both sides are
# `Nat.mul(h1, h2) + S.dot(t1, t2)`.
def L.dot_cons(h1, t1, h2, t2):
  {==}

# The induction is on `xs`, and in the cons case on `ys` as well. Where the
# second list is empty both sides compute to `0n`. Where it is a cons cell, the
# step leaves `Nat.mul(h, k)` in front of a walk over the two tails on the left,
# and the same product in front of a walk that has had `P.take` applied to its
# second list on the right; the hypothesis at `(t, u)` replaces the second of
# those with the first.
def L.dot_shorter(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      match ys:
        case Nil{}:
          {==}
        case k <> u:
          %L.dot_shorter(t, u) : {Nat.mul(h, k) + S.dot(t, u) == Nat.mul(h, k) + _ : Nat}
          {==}
