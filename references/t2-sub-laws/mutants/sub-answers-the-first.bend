import Base

# The projection onto the minuend: the subtrahend is matched on but never acted
# on, so the answer is the first argument. `sub_zero` holds -- `sub(x, 0n)` is
# `x` -- and `sub_succ` is what rejects it: the law wants `pred` of the smaller
# result where the body answers `x` again, and `pred(x)` is `x` only for the
# arguments that happen to be `0n` or `1n`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+ap
