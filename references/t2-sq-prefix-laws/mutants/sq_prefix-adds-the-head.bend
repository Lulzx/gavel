import Base
import ./prelude.bend as P

# The head is added instead of being squared first -- the slip of writing `h`
# where `P.sq(h)` belongs. `sq_prefix_zero` holds, and `sq_prefix_len` rejects
# it: on the diagonal the body adds up the elements of the list where the law
# adds up their squares, and those differ as soon as an element other than `0n`
# or `1n` is in the list.
def sq_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          h + sq_prefix(k, t)
