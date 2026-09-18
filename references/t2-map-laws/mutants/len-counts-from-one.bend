import Base

# `len` counts from one: the empty case answers `1n` and the cons case adds one,
# so every length is one too large. It reached tier 4 -- full reward -- before
# `len_single` existed, because `len_map_cons` relates `len` to itself through
# `map` and `map` preserves length, so the same offset appears on both sides and
# cancels. Measured: bare tier 2, killed first at `LAWS.len_single`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      1n + len(t)

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n+h) <> map(t)
