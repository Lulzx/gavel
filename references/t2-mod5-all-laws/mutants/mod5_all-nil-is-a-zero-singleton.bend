import Base
import ./prelude.bend as P

# The empty input is answered with a one-cell list holding `0n`. No law is
# stated at `Nil{}` directly; this is the escape probe, and the append law at
# `xs = Nil{}` is what has to refuse it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mod5_all_single`.
def mod5_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      P.mod5(h) <> mod5_all(t)
