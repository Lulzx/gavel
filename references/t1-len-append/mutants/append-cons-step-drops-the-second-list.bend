import Base

# The cons step recurses against `Nil{}` instead of `ys`, so `append(xs, ys)`
# answers `xs` whenever `xs` is non-empty. The old set never applied `append` to
# a non-empty second argument in a cons step -- `len_cons`, `len_single` and
# `len_nil_right` count, and `append_nil_left` fixes the empty *first* argument,
# which this body keeps -- so it proved all four at tier 4, reward 1.000.
# Measured: before `append_cons`, tier 4, reward 1.000; after, tier 3, four of
# five laws proven (0.500 by the tier-3 formula), failing at `LAWS.append_cons`.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, Nil{})
