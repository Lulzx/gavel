import Base

# An off-by-one in the recursive case: the successor is carried back out of the
# recursion, so the body is `sub` plus one on every pair of successes. `sub_zero`
# holds -- the base case is untouched -- and `sub_succ` rejects it: at `y = 0n`
# the law's left-hand side is `1n + sub(ap, 0n)`, which is `1n + ap`, where the
# right-hand side is `pred(1n + ap)`, which is `ap`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n + sub(ap, bp)
