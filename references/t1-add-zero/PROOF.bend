import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The induction is in `x`: the base case computes to 0n on both sides, and the
# step case rewrites the occurrence of `p` in the goal with the hypothesis.
def L.add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}
      {==}
