import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Both arguments are literals, so the outer match takes its zero case and the
# inner match takes its zero case, and both sides are `P.Eq{}`.
def L.cmp_zero_zero():
  {==}

# The outer match takes its zero case and the inner one sees a successor, so
# both sides reduce to `P.Lt{}`.
def L.cmp_zero_succ(k):
  {==}

# The outer match takes its successor case and the inner one sees a zero, so
# both sides reduce to `P.Gt{}`.
def L.cmp_succ_zero(k):
  {==}

# Two successors step one off each side, so both sides reduce to `cmp` of what
# is below them.
def L.cmp_succ_succ(a, b):
  {==}

# Inductive in `a`. The step reduces `cmp(1n + p, 1n + p)` to `cmp(p, p)`, which
# is the hypothesis, and the base case is the zero-zero case of the match.
def L.cmp_self(a):
  match a:
    case 0n:
      {==}
    case 1n+p:
      L.cmp_self(p)

# Inductive in `a` and then in `b`. Three of the four leaves are definitional:
# two zeroes, a zero against a successor and a successor against a zero each
# reduce on both sides to the same constructor, `P.flip` included. The fourth
# steps one off each side of both calls at once, and is the hypothesis at `p`
# and `q`.
def L.cmp_antisym(a, b):
  match a:
    case 0n:
      match b:
        case 0n:
          {==}
        case 1n+q:
          {==}
    case 1n+p:
      match b:
        case 0n:
          {==}
        case 1n+q:
          L.cmp_antisym(p, q)
