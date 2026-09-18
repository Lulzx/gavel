import Base

# The mirror body: only the right list's element survives. On the diagonal this
# is the identity list, so the element law fails the same way; the nil laws and
# the length law hold, which is what makes the pair of bodies a probe of "which
# element, not which length". Measured: `proof_tier=3 bare_tier=2`, first
# failure at `LAWS.zip_sum_self`.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          h2 <> zip_sum(t1, t2)
