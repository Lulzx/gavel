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

def L.add_plus(x, y):
  %Policy.add_plus(x, y) : {S.add(x, y) == _ : Nat}
  {==}

# The induction is in `x`. The step reduces `mul(1n+p, 1n)` to
# `1n + mul(p, 1n)`, which the hypothesis rewrites at `p`.
def L.mul_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.mul_one(p) : {1n+S.mul(p, 1n) == 1n+_ : Nat}
      {==}

# `mul` steps on its first argument, so the step law is reflexive.
def L.mul_succ(x, y):
  {==}

# `mul`'s own `0n` case, read back: the left-hand side computes on the `0n`
# branch of the body's first match whatever the second argument is.
def L.mul_zero(y):
  {==}

