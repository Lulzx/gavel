import Base
import ./prelude.bend as P

# PROBE. Every stopping law holds -- zero and one still answer `0n`, and the
# budget still ends the walk -- but the odd branch subtracts one instead of
# adding it, so the number the step hands on is wrong.
def collatz_len(fuel: Nat, +n: Nat) -> Nat:
  match fuel:
    case 0n:
      0n
    case 1n+f:
      match n:
        case 0n:
          0n
        case 1n+0n:
          0n
        case 1n+1n+p:
          1n + collatz_len(f, Bool.pick(Nat, P.is_even_b(n), P.half(n), Nat.mul(3n, n) - 1n))
