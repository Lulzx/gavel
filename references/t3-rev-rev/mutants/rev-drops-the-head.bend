import Base
import ./prelude.bend as P

# The recursion is written and the result is returned without the head, so the
# answer is the reversal of nothing. `rev_len` fails at every non-empty list.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.rev_snoc`.
def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      rev(t)
