import Base

# The cons case answers `ys` directly instead of consing the head onto the
# recursive call. An `append` that is right only on the empty list: the first
# list is thrown away and the result is always the second argument. This is
# the base case leaking into every case.
# Measured: `proof_tier=3 bare_tier=2`, proven ['len_cons'], first failure
# at `LAWS.len_append`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      ys

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
