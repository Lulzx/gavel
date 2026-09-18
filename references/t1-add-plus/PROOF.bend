import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The induction is in `x`, so `y` stays general: the base case computes to the
# same term on both sides, and the step rewrites at `p`.
def L.add_plus(x, y):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_plus(p, y) : {1n + S.add(p, y) == 1n + _ : Nat}
      {==}
