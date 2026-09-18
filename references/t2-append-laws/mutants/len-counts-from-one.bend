import Base

# The empty list is counted as one, so `len` is one more than the real length.
# `len_cons` still holds -- both sides shift by the same constant -- and only
# `len_append` sees the shift, because it adds two lengths.
# Measured: `proof_tier=3 bare_tier=2`, proven ['len_cons'], first failure
# at `LAWS.len_append`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      1n + len(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
