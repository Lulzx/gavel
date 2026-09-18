import Base

# The step answers `0n`, so `double` is zero everywhere past the base case. The
# generated constant body changes both branches; this one keeps the base and
# drops the step, which is the mistake the recursion's shape invites.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.double_eq_add`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def double(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      0n
