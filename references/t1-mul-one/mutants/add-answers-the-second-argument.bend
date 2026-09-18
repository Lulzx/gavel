import Base

# The multiplication is the reference's and `add` is not: with `add` answering
# its second argument, the step `add(b, mul(p, b))` collapses to `mul(p, b)`, so
# `mul` is `0n` everywhere. Both laws are stated over `S.mul`, so both see it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['mul_succ'], first failure
# at `LAWS.mul_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      add(b, mul(p, b))
