import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the empty list is the `Nil{}` case of the match, which is
# `x <> Nil{}` on the nose.
def L.snoc_nil(x):
  {==}

# An induction in `xs`. The `Nil{}` case is definitional on both sides; the cons
# case reduces both sides to the same head consed onto `snoc` of the tail, which
# is where the hypothesis at `t` applies.
def L.snoc_append(xs, ys, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.snoc_append(t, ys, x) : {h <> S.snoc(P.append(t, ys), x) == h <> _ : List<Nat>}
      {==}
