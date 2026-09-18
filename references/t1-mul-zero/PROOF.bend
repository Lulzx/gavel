import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `add` on the left of a `+` is Base's addition on the right. Free in `y`, so
# the induction in `x` passes it through unchanged.
def Policy.add_plus(x: Nat, y: Nat) -> {S.add(x, y) == x + y : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_plus(p, y) : {1n + S.add(p, y) == 1n + _ : Nat}
      {==}

# The law is `Policy.add_plus`'s statement, so the proof is the lemma itself:
# after citing it the goal is `x + y == x + y`.
def L.add_plus(x, y):
  %Policy.add_plus(x, y) : {S.add(x, y) == _ : Nat}
  {==}

# The induction is in `x`. The step reduces `mul(1n+p, 0n)` to `mul(p, 0n)`
# because `add(0n, _)` is the identity, and the hypothesis then closes it.
def L.mul_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.mul_zero(p) : {S.mul(p, 0n) == _ : Nat}
      {==}

# `mul` steps on its first argument, so the left side is `add(y, mul(x, y))` by
# reduction and the right side is Base's `+`. `y` is named twice -- once by the
# lemma and once under `S.mul` -- so it is re-bound reusable first.
def L.mul_succ_left(x, y):
  +y = y
  %Policy.add_plus(y, S.mul(x, y)) : {S.add(y, S.mul(x, y)) == _ : Nat}
  {==}

# `mul` matches its first argument, so `mul(0n, y)` is `0n` by unfolding alone,
# whatever `y` is.
def L.mul_zero_left(y):
  {==}
