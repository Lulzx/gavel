import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case of the match steps the head back and finds `Nil{}`
# as the tail.
def L.pred_all_single(h):
  {==}

# An induction in `xs`. The `Nil{}` case is the empty case of the match, on both
# sides; the cons case conses the stepped-back head onto the hypothesis at `t`,
# so the two sides meet under the `<>`.
def L.pred_all_append(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.pred_all_append(t, ys) : {P.pred(h) <> S.pred_all(P.append(t, ys)) == P.pred(h) <> _ : List<Nat>}
      {==}
