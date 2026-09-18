import Base

# The step adds the second argument twice, so the answer is `a * 2b`: at `1n`
# the law asks for `x` and this body answers `2x`. `mul_succ` fails too, since
# its right-hand side has one copy of the factor and this body produces two.
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
      add(b, add(b, mul(p, b)))
