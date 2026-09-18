import Base

# Each element is counted twice: the step adds `2n` rather than `1n`, so `len`
# answers twice the length. The base case is right and the step is uniformly
# wrong.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.len_cons`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      2n + len(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
