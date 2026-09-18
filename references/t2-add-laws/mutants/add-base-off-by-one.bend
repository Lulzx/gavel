import Base

# A body a person would plausibly write: the base case adds one to the second
# argument, so the whole function is one too large. Rejected by `add_zero`:
# `add(0n, 0n)` reduces to `1n + 0n`, which is `1n`, where the law wants `0n`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      1n + b
    case 1n+p:
      1n + add(p, b)
