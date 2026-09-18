import Base

# The first pair is summed and the recursion is gone, so any two non-empty lists
# give a one-element answer. Both nil laws hold definitionally; the length law
# fails at any pair of lists longer than one, where the answer should grow.
# Measured: `proof_tier=3 bare_tier=2`, the two nil laws proven, first failure
# at `LAWS.zip_sum_len`.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          (h1 + h2) <> Nil{}
