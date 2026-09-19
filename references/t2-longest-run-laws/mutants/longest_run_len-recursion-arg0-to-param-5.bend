import Base
import ./prelude.bend as P

# The reference: the longest run is the better of the block that starts at the
# first element and the longest run in the rest of the list.
def longest_run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> +t:
      Nat.max(P.run_len(h <> t), longest_run_len(xs))
