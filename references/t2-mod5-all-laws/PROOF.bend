import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match maps the head and finds `Nil{}` as
# the tail.
def L.mod5_all_single(h):
  {==}

# An induction in `xs`. The `Nil{}` case is the empty case of the match, on
# both sides; the cons case conses the mapped head onto the hypothesis at `t`,
# so the two sides meet under the `<>`.
def L.mod5_all_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.mod5_all_append(t, ys) : {P.mod5(h) <> S.mod5_all(P.append(t, ys)) == P.mod5(h) <> _ : List<Nat>}
      {==}
