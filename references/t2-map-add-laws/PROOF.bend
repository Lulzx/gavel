import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match adds `n` to the head and finds
# `Nil{}` as the tail.
def L.map_add_single(h, n):
  {==}

# An induction in `xs`, with `n` fixed across the instances. The `Nil{}` case is
# the empty case of the match, on both sides; the cons case conses `h + n` onto
# the hypothesis at `(t, n)`, so the two sides meet under the `<>`.
def L.map_add_append(xs, ys, n):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.map_add_append(t, ys, n) : {(h + n) <> S.map_add(P.append(t, ys), n) == (h + n) <> _ : List<Nat>}
      {==}
