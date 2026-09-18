import Base

# The empty input is answered with a one-cell list holding `1n`. No law is
# stated at `Nil{}` directly; this is the escape probe, and the append law at
# `xs = Nil{}` is what has to refuse it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.inc_all_single`.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      (h + 1n) <> inc_all(t)
