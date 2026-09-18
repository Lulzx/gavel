import Base

# The projection onto the subtrahend: the last case answers the second argument
# and the base case leaks it into `sub(0n, 1n+bp)`, so the minuend is never used.
# `sub_zero` rejects it -- at `0n` the law wants `x` and the body answers
# `0n` -- and `sub_succ` rejects it too, since the answer does not step down with
# the subtrahend.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n+bp
