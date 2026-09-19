import Base
import ./prelude.bend as P

# PROBE. The three empty/singleton anchors hold and the step keeps the gate, but
# a matched pair is counted as two positions rather than one. The first attempt
# at this probe swapped the two tails, and the checker refused it as a
# non-decreasing self-call -- `lcp_len(u, t)` passes an argument that is not a
# subterm of `xs`, so the swap is unrunnable rather than unproven. The tail swap
# is therefore not a hole this law set has to close; the pair's weight is.
def lcp_len(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          P.gate(P.is_eq(h, k), 2n + lcp_len(t, u))
