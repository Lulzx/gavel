import Base
import ./prelude.bend as P

# PROBE. The no-fuel law holds and the step keeps the parity test, but it
# recurses on the number unchanged, spending the width without shrinking the
# argument.
def is_pow2(w: Nat, +n: Nat) -> Bool:
  match w:
    case 0n:
      False{}
    case 1n+p:
      match n:
        case 0n:
          False{}
        case 1n+0n:
          True{}
        case 1n+1n+q:
          Bool.and(P.is_even_b(n), is_pow2(p, n))
