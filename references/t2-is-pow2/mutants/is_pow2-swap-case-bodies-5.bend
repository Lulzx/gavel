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
      match n:
        case 0n:
          Bool.and(P.is_even_b(n), is_pow2(p, P.half(n)))

        case 1n+0n:
          True{}
        case 1n+1n+q:
          False{}
