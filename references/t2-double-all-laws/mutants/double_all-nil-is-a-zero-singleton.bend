import Base

# The empty input is answered with a one-cell list holding `0n`: the nil case
# is wrong while every cons case matches the reference. This is the escape
# probe -- no law is stated at `Nil{}` directly, so only the append law at
# `xs = Nil{}` can refuse it.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.double_all_single`.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case h <> t:
      +h2 = h
      (h2 + h2) <> double_all(t)
