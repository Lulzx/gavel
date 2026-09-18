import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Both laws are inductive in `x`, so each proof is: the base case computes to
# the same term on both sides, and the step case rewrites with the induction
# hypothesis at p.
def L.add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}
      {==}

def L.add_succ(x, y):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_succ(p, y) : {1n+S.add(p, 1n+y) == 1n+_ : Nat}
      {==}
