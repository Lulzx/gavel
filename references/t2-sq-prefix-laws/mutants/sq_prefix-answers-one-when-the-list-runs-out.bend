import Base
import ./prelude.bend as P

# The inner `Nil{}` case answers `1n`. It reached tier 4 -- full reward --
# before `sq_prefix_nil` existed: `sq_prefix_len` constrains only the diagonal,
# where the count and the length agree, so the case where the list runs out
# before the count is reached by neither law. Measured: bare tier 2, killed
# first at `LAWS.sq_prefix_nil`.
def sq_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          1n
        case h <> t:
          P.sq(h) + sq_prefix(k, t)
