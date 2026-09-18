import Base

# `mul` answers its second argument, so `mul(0n, x)` is `x` and the zero law --
# which is the law the comment says closes the argument-ignoring bodies -- fails
# against `0n`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['add_zero'], first failure
# at `LAWS.mul_two`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b
