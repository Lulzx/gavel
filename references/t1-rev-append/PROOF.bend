import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The base anchor. `reverse(Nil{})` unfolds to `Nil{}`, so the two sides of the
# law are the same term and there is nothing to say about them.
def L.rev_nil():
  {==}

# `append` matches on its first argument, so with a variable `xs` the goal does
# not reduce on its own. Both sides unfold to the same cons cell.
def L.rev_append(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      # The hypothesis has `reverse(append(t, x <> Nil{}))` on the left, which
      # is where the goal has it too, so it is flipped before it is applied.
      # What is left is `append(x <> reverse(t), h <> Nil{})` against
      # `x <> append(reverse(t), h <> Nil{})`, which is `append`'s cons step.
      %Equal.sym(List<Nat>, S.reverse(P.append(t, x <> Nil{})), x <> S.reverse(t), L.rev_append(t, x)) : {P.append(_, h <> Nil{}) == x <> P.append(S.reverse(t), h <> Nil{}) : List<Nat>}
      {==}
