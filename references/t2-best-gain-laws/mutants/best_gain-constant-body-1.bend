import Base
import ./prelude.bend as P

# The reference: the head's best rise into the tail alongside the best gain
# inside the tail, and zero where there is no pair at all.
def best_gain(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      0n
