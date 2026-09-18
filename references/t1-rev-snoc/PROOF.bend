import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `snoc` on `Nil{}` is a cons cell, so `reverse` walks it and both sides are
# `x <> Nil{}`.
def L.rev_snoc(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      # The induction hypothesis reads left to right -- the goal has
      # `reverse(snoc(t, x))` on the left and `x <> reverse(t)` on the right --
      # so it is flipped before it is applied. What is left is
      # `append(x <> reverse(t), h <> Nil{})` against
      # `x <> append(reverse(t), h <> Nil{})`, which is `append`'s cons step.
      %Equal.sym(List<Nat>, P.reverse(S.snoc(t, x)), x <> P.reverse(t), L.rev_snoc(t, x)) : {P.append(_, h <> Nil{}) == x <> P.append(P.reverse(t), h <> Nil{}) : List<Nat>}
      {==}
