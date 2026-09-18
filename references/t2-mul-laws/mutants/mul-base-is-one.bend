import Base

# The base case answers `1n` instead of `0n`, so `mul(0n, b)` is one and every
# product is one too large. This is the base-case probe: zero times anything
# is not pinned by any law's left-hand side directly -- the left-identity law
# only reaches the base through `add`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['mul_succ'], first failure
# at `LAWS.mul_one_left`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      1n
    case 1n+p:
      add(b, mul(p, b))
