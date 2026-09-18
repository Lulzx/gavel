import Base

# `mul` is `0n` for every non-zero first argument, so multiplying by one gives
# zero and the law fails against the variable on its right-hand side. The
# generated constant body `0n` also changes the base; this one keeps the
# reference's base and stops at the step.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mul_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      0n
