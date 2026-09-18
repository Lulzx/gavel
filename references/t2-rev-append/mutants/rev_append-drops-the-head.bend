import Base

# The cons case recurses without moving the head onto the accumulator, so a
# nonempty first list is dropped one cell at a time. The singleton law asks
# for `h <> ys` and gets `ys`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.rev_append_single`.
def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      rev_append(t, ys)
