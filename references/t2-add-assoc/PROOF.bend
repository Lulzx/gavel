import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Both laws are inductive in `x`: the base case computes to the same term on
# both sides, and the step case rewrites with the induction hypothesis at p.
def L.add_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_one(p) : {1n+S.add(p, 1n) == 1n+_ : Nat}
      {==}

def L.add_assoc(x, y, z):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_assoc(p, y, z) : {1n+S.add(S.add(p, y), z) == 1n+_ : Nat}
      {==}
