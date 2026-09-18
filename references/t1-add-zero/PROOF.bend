import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_zero(p) : {S.add(1n+p, 0n) == 1n+_ : Nat}
      {==}
