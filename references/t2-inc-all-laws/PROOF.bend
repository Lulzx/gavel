import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match increments the head and finds
# `Nil{}` as the tail.
def L.inc_all_single(h):
  {==}

# An induction in `xs`. The `Nil{}` case is the empty case of the match, on both
# sides; the cons case conses the incremented head onto the hypothesis at `t`,
# so the two sides meet under the `<>`.
def L.inc_all_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.inc_all_append(t, ys) : {(h + 1n) <> S.inc_all(P.append(t, ys)) == (h + 1n) <> _ : List<Nat>}
      {==}
