import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The induction is in `x`. The step reduces `mul(1n+p, 0n)` to `mul(p, 0n)`
# because `add(0n, _)` is the identity, and the hypothesis then closes it.
def L.mul_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.mul_zero(p) : {S.mul(p, 0n) == _ : Nat}
      {==}

# Also inductive in `x`: the step reduces `mul(1n+p, 1n)` to
# `1n + mul(p, 1n)`, where `add(x, 0n)` has already collapsed to `x`.
def L.mul_one_left(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.mul_one_left(p) : {1n + S.add(p, 0n) == 1n + _ : Nat}
      {==}
