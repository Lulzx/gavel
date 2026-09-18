import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.min_self(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.min_self(p) : {1n+S.min(p, p) == 1n+_ : Nat}
      {==}

def L.min_comm(x, y):
  match x:
    case 0n:
      match y:
        case 0n:
          {==}
        case 1n+q:
          {==}
    case 1n+p:
      match y:
        case 0n:
          {==}
        case 1n+q:
          %L.min_comm(p, q) : {1n+S.min(p, q) == 1n+_ : Nat}
          {==}
