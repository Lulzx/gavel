import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The first list is a literal `Nil{}`, so the outer match takes its empty branch
# and neither of the other two is looked at.
def L.zip3_nil_left(ys, zs):
  {==}

# With a variable first list the outer match is stuck, so the induction is on
# `xs`. The cons case reaches the inner match on the literal `Nil{}`, which
# picks the empty answer on both sides.
def L.zip3_nil_mid(xs, zs):
  match xs:
    case Nil{}:
      {==}
    case h1 <> t1:
      {==}

# Induction on `xs` and then on `ys`: the first match steps on the cons cell and
# the second is stuck until `ys` is split. The innermost case is the match on the
# literal `Nil{}` for `zs`, which answers `Nil{}` on both sides.
def L.zip3_nil_right(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h1 <> t1:
      match ys:
        case Nil{}:
          {==}
        case h2 <> t2:
          {==}

# `len` folds over `zip3` and `min3` steps through all three of its arguments,
# so the hypothesis at `(t1, t2, t3)` leaves `1n + P.min3(P.len(t1), P.len(t2),
# P.len(t3))` on both sides.
def L.zip3_len(xs, ys, zs):
  match xs:
    case Nil{}:
      {==}
    case h1 <> t1:
      match ys:
        case Nil{}:
          {==}
        case h2 <> t2:
          match zs:
            case Nil{}:
              {==}
            case h3 <> t3:
              %L.zip3_len(t1, t2, t3) : {1n + P.len(S.zip3(t1, t2, t3)) == 1n + _ : Nat}
              {==}

# All three matches unfold to a cons over the same three heads, so the two sides
# are the same term.
def L.zip3_cons(h1, t1, h2, t2, h3, t3):
  {==}
