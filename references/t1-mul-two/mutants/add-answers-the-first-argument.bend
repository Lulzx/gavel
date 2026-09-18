import Base

# The multiplication is the reference's and `add` is not: `add` answers its
# first argument, so `mul(2n, x)` becomes `x + x` -- the law's right-hand side
# written with `S.add` on the left of the `+` -- and it is `add_zero` that
# fails, since `S.add(x, 0n)` is then `x`... only if `x` is what `add` reads.
# The law's comment names this body: it passes the two law and fails this one.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + p

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      add(b, mul(p, b))
