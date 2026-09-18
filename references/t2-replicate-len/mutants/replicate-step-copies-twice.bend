import Base
import ./prelude.bend as P

# The step places two copies where the law places one -- the slip of writing the
# copy once for the count and once for the element. `replicate_succ` rejects it:
# the law's left-hand side reduces to `x <> replicate(n, x)` where the body's
# answer has an extra `x` in front of that. `replicate_len` rejects it too, since
# the answer then has twice as many elements as were asked for.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> (x <> replicate(k, x))
