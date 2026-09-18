import Base
import ./prelude.bend as P

# The head is kept and the tail is dropped, so `rev` answers a one-element list
# for every non-empty input. `rev_len` fails at any list of two or more; the
# generated constant body `Nil{}` differs from this one only in which of the two
# it keeps. Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure
# at `Policy.rev_snoc`.
def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> Nil{}
