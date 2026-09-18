import Base

# `drop` steps but never removes: the head goes into the answer and the count
# still decreases, so `drop(n, xs)` is `xs` with only the first `n` positions
# visited. The composition law fails at any non-zero count, where the two halves
# do not rebuild the argument; `drop_drop` fails as well. Measured:
# `proof_tier=3 bare_tier=2`, `take_len` proven, first failure at
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
          h <> take(k, t)

def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> drop(k, t)
