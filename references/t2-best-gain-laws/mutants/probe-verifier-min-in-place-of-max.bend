import Base
import ./prelude.bend as P

# PROBE. Both anchors hold -- `min` of two zeros is zero -- and the step keeps
# the prelude's `P.max_sub`, but takes the smaller of the two candidates rather
# than the larger. A reading of "best" that survives would be a hole.
def best_gain(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      Nat.min(P.max_sub(h, t), best_gain(t))
