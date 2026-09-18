import Base

# The mirror body: `mul` answers its second argument. `mul_one` asks it for
# `1n == x` and fails at a variable, and `mul_succ` fails as well. The law
# comment names this body as the one `mul_succ` exists for.
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
      b
