import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Three facts about `add`. `mul_one_left` uses the first, `mul_succ` the other
# two. All three are clean inductions in `x`.
def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}
      {==}

def Policy.add_succ(x: Nat, y: Nat) -> {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ(p, y) : {1n+S.add(p, 1n+y) == 1n+_ : Nat}
      {==}

def Policy.add_assoc(x: Nat, y: Nat, z: Nat) ->
    {S.add(S.add(x, y), z) == S.add(x, S.add(y, z)) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, y, z) : {1n+S.add(S.add(p, y), z) == 1n+_ : Nat}
      {==}

# `mul_one_left` is an induction in `x` in which `mul(1n, x)` unfolds to
# `add(x, 0n)`, so its step case is `add_zero` at `p`, used in the direction
# that replaces the `add(p, 0n)` in the goal by `p`.
def L.mul_one_left(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.add(p, 0n), p, Policy.add_zero(p)) : {1n+_ == 1n+p : Nat}
      {==}

# `mul_succ` is an induction in `x` as well, but its step case needs both other
# facts about `add`: the tail is folded first, then reassociated, then the
# successor is moved back out. The helper takes `+x`/`+y` so that both may be
# named more than once across those three rewrites.
def Policy.mul_succ(+x: Nat, +y: Nat) -> {S.mul(x, 1n+y) == S.add(S.mul(x, y), x) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.mul(p, 1n+y), S.add(S.mul(p, y), p), Policy.mul_succ(p, y)) : {1n+S.add(y, _) == S.add(S.add(y, S.mul(p, y)), 1n+p) : Nat}
      %Policy.add_assoc(y, S.mul(p, y), p) : {1n+_ == S.add(S.add(y, S.mul(p, y)), 1n+p) : Nat}
      %Equal.sym(Nat, S.add(S.add(y, S.mul(p, y)), 1n+p), 1n+S.add(S.add(y, S.mul(p, y)), p), Policy.add_succ(S.add(y, S.mul(p, y)), p)) : {1n+S.add(S.add(y, S.mul(p, y)), p) == _ : Nat}
      {==}

def L.mul_succ(x, y):
  Policy.mul_succ(x, y)
