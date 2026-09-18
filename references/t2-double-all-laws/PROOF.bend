import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match doubles the head and finds `Nil{}` as
# the tail.
def L.double_all_single(h):
  {==}

# An induction in `xs`. The `Nil{}` case is the empty case of the match, on both
# sides; the cons case conses the doubled head onto the hypothesis at `t`, so
# the two sides meet under the `<>`.
def L.double_all_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.double_all_append(t, ys) : {(h + h) <> S.double_all(P.append(t, ys)) == (h + h) <> _ : List<Nat>}
      {==}
