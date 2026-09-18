import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the cons case appends `reverse(Nil{})`, which is `Nil{}`, to the
# one-element list.
def L.reverse_single(h):
  {==}

# An induction in `xs`. The `Nil{}` case is the one-element case of `reverse`;
# the cons case uses the hypothesis in the direction that turns
# `reverse(snoc(t, x))` into `x <> reverse(t)`, and what is left is
# `append(x <> reverse(t), h <> Nil{})` against `x <> append(reverse(t), h <> Nil{})`,
# which reduces to the same list because `append` matches on its first argument.
def L.reverse_snoc(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<Nat>, S.reverse(P.snoc(t, x)), x <> S.reverse(t), L.reverse_snoc(t, x)) : {P.append(_, h <> Nil{}) == x <> P.append(S.reverse(t), h <> Nil{}) : List<Nat>}
      {==}
