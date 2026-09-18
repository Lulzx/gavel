import Base
import ./prelude.bend as P

# The count is walked but the squares are not added: the step hands back the
# count. `sq_prefix_zero` holds -- the count reaches zero before the list is
# looked at -- and `sq_prefix_len` is what rejects it: on the diagonal the law
# wants the sum of squares and the body answers `len(xs)`.
def sq_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          1n+k
