import Base
import ./prelude.bend as P

# PROBE. Both anchors hold and the step keeps the `Nat.max`, but it measures the
# block starting at the *second* element, so a run that starts at the head is
# missed.
def longest_run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      Nat.max(P.run_len(t), longest_run_len(t))
