import Base

# The step adds one instead of two, so the answer is the argument rather than
# its double. `double_eq_add` holds only against a matching `add` and the
# reference's `add` is the sum of two copies, so the law fails; `double_succ`
# fails as well, since the law names `1n+1n+S.double(x)`.
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
      1n + double(p)
