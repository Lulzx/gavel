import Base

# The cons case conses the head onto `Nil{}` rather than onto the accumulator,
# so everything already accumulated is thrown away at the next step. The
# singleton law asks for `h <> ys` at a variable `ys`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.rev_append_single`.
def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> Nil{}
