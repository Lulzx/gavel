import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `pred_succ` is definitional: `pred` is the deconstructor of `Nat`, so
# `pred(1n+x)` already computes to `x`.
def L.pred_succ(x):
  {==}

# `pred_add_succ` splits on `x`. The successor case has to move the successor
# out of the second argument of `add`, which is the helper below; the equation
# is used flipped so that the occurrence in the goal is the one it rewrites.
def Policy.add_succ(x: Nat, y: Nat) -> {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ(p, y) : {1n+S.add(p, 1n+y) == 1n+_ : Nat}
      {==}

def L.pred_add_succ(x, y):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.add(p, 1n+y), 1n+S.add(p, y), Policy.add_succ(p, y)) : {_ == 1n+S.add(p, y) : Nat}
      {==}
