import Base

# The recursion is the reference's and the head is not put back, so the answer
# is the `n` elements after the first: the right length for a long list and the
# wrong elements. `take_len` holds wherever the list is at least `n` long and
# fails where it is short, and `take_drop` fails outright. Measured:
# `proof_tier=3 bare_tier=2`, `drop_drop` proven, first failure at
# `LAWS.take_drop`.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          take(k, t)

def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          drop(k, t)
