import Base

# The arguments are added instead of subtracted -- the classic sign slip, here
# written out as the two arguments summed in the recursive case. `sub_zero`
# holds, since adding nothing leaves `x`, and `sub_succ` rejects it: the law
# wants each step of the subtrahend to take `pred` off the result, and the body's
# answer grows with the subtrahend instead.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      (1n+ap) + (1n+bp)
