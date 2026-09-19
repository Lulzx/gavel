import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the width so the recursion
# consumes a structural argument, and the inner match is on the number, one
# constructor at a time. Zero is not a power of two, one is, and anything above
# one is a power of two exactly when it is even and half of it is.
def is_pow2(w: Nat, +n: Nat) -> Bool:
  match w:
    case 0n:
      False{}
    case 1n+p:
      False{}
