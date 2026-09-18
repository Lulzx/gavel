import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# An induction in `x`. The zero case is the first pattern of the match; the
# successor case is the fourth, where both arguments are `1n+p`, so the call
# unfolds to `1n+max(p, p)` and the hypothesis turns it back into `1n+p`.
def L.max_self(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.max_self(p) : {1n+S.max(p, p) == 1n+_ : Nat}
      {==}

# Two nested inductions, on `x` and then on `y`. The `0n` cases are decided by
# the second and third patterns of the match; the `1n+p` / `1n+q` case reduces
# to `1n + max` on both sides and reuses the hypothesis at `(p, q)`.
def L.max_comm(x, y):
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
          %L.max_comm(p, q) : {1n+S.max(p, q) == 1n+_ : Nat}
          {==}

# The zero law is not definitional: with the second argument a variable the
# match cannot choose between the two zero patterns, so it splits on `y`.
def L.max_zero_left(y):
  match y:
    case 0n:
      {==}
    case 1n+yp:
      {==}

# Definitional: both arguments are successors, so the match takes the last case
# and answers `1n + max(p, q)`.
def L.max_succ_succ(p, q):
  {==}
