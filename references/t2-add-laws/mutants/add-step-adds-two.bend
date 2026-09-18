import Base

# A body a person would plausibly write: the step case adds the successor twice,
# an off-by-one in the increment rather than in the recursion. Rejected by
# `add_zero`: `add(1n+p, 0n)` reduces to `1n + 1n + add(p, 0n)`, which is
# `2n+p` by the induction hypothesis, where the law wants `1n+p`. `add_succ`
# fails on the same body, for the same reason one level down.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + 1n + add(p, b)
