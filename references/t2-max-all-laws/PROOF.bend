import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match raises the head and finds `Nil{}` as
# the tail.
def L.max_all_single(h, n):
  {==}

# An induction in `xs`. The `Nil{}` case is the empty case of the match, on both
# sides; the cons case conses the raised head onto the hypothesis at `t`, so the
# two sides meet under the `<>`.
def L.max_all_append(xs, ys, n):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.max_all_append(t, ys, n) : {P.max(h, n) <> S.max_all(P.append(t, ys), n) == P.max(h, n) <> _ : List<Nat>}
      {==}
