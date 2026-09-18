import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match doubles the head and finds `Nil{}` as
# the tail.
def L.dup_all_single(h):
  {==}

# An induction in `xs`. The `Nil{}` case is the empty case of the match, on both
# sides; the cons case puts the two copies of the head outside on both sides,
# leaving the hypothesis at `t` twice under the same pair of `<>`s.
def L.dup_all_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.dup_all_append(t, ys) : {h <> (h <> S.dup_all(P.append(t, ys))) == h <> (h <> _) : List<Nat>}
      {==}
