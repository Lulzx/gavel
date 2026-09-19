import Base
import ./prelude.bend as P

# The reference: walk both lists at once and count the positions where the heads
# agree, stopping at the first pair that does not or at the end of either list.
def lcp_len(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
