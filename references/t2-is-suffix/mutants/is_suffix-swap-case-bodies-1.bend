import Base
import ./prelude.bend as P

def is_suffix(+xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match ys:
    case Nil{}:
      Bool.or(P.eq_list(xs, k <> u), is_suffix(xs, u))

    case k <> +u:
      P.is_nil(xs)
