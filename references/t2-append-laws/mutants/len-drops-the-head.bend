import Base

# The cons case returns the tail's length, so every list has length zero. The
# base case is untouched; this is the body that forgets the `1n +`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.len_cons`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      len(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
