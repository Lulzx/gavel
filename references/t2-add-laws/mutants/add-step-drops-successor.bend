import Base

# A body a person would plausibly write: the step case recurses but forgets to
# add the successor back, so the body counts down to the base without ever
# counting up. Rejected by `add_zero`: `add(1n+p, 0n)` reduces to
# `add(p, 0n)`, which the induction hypothesis makes `p`, where the law wants
# `1n+p`. `add_succ` fails on the same body as well.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      add(p, b)
