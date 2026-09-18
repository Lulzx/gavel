import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.sub_zero_right(x: Nat) -> {S.sub(x, 0n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      {==}

def L.sub_cancel(x, y):
  match x:
    case 0n:
      %Policy.sub_zero_right(y) : {S.sub(y, 0n) == _ : Nat}
      {==}
    case 1n+p:
      %L.sub_cancel(p, y) : {S.sub(p + y, p) == _ : Nat}
      {==}

# `sub` matches both arguments, so `sub(0n, y)` is stuck on `y` and the proof
# splits it: the literal `0n` picks the first branch and `1n+yp` the second,
# and both answer `0n`.
def L.sub_saturates(y):
  match y:
    case 0n:
      {==}
    case 1n+yp:
      {==}
