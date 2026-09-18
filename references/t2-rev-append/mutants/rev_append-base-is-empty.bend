import Base

# The empty input is answered with `Nil{}` instead of the accumulator, so the
# accumulator is thrown away at the bottom of the recursion. This is the
# escape probe for the base case: the singleton law reaches it through the
# recursive call.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.rev_append_single`.
def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      rev_append(t, h <> ys)
