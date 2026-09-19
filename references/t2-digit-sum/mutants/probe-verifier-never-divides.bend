import Base
import ./prelude.bend as P

# PROBE. The no-fuel law holds and the step reads the low digit with the
# prelude's `Nat.mod`, but it hands the number on unchanged, so it counts the
# same digit at every width.
def digit_sum(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      Nat.mod(n, 10n) + digit_sum(p, n)
