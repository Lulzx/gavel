import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `append_nil_left` is definitional: `append` matches on its first argument, so
# appending `Nil{}` on the left already computes away.
def L.append_nil_left(xs):
  {==}

# `len_append` is inductive in `xs`.
def L.len_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.len_append(t, ys) : {1n+S.len(S.append(t, ys)) == 1n+_ : Nat}
      {==}
