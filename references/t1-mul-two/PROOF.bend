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

# Adding zero on the right changes nothing. This one is needed because Base's
# `+` does not reduce on a variable, so `x + 0n` is stuck; `S.add` does reduce on
# its first argument, and the induction in `x` is what removes it.
def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + S.add(p, 0n) == 1n + _ : Nat}
      {==}

# `mul(2n, x)` reduces to `add(x, add(x, 0n))`, so the goal is
# `add(x, add(x, 0n)) == x + x`: fold the right side into `S.add` form, then
# drop the `add(x, 0n)`. `x` is named twice, so it is re-bound reusable first.
def L.mul_two(x):
  +x = x
  %Policy.add_plus(x, x) : {S.add(x, S.add(x, 0n)) == _ : Nat}
  %Policy.add_zero(x) : {S.add(x, S.add(x, 0n)) == S.add(x, _) : Nat}
  {==}
