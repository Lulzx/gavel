import Base
import ./prelude.bend as P

# The step steps both arguments down but forgets to add the head's square, so the
# answer sums the squares of everything after the first element. `sq_prefix_zero`
# holds -- the head is never reached at count zero -- and `sq_prefix_len` rejects
# it: on the diagonal the body is short by `sq` of the first element.
def sq_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          sq_prefix(k, t)
