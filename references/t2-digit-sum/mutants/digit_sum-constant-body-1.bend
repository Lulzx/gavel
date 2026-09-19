import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the width, so the recursion
# consumes a structural argument, and each step takes the low base-10 digit off
# with `Nat.mod` and keeps dividing by ten with `Nat.div`. Reading the digits
# least significant first means the sum does not depend on the order.
def digit_sum(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      0n
