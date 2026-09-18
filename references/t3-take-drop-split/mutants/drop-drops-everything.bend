import Base

# Any non-zero count empties the list in one step, so `drop` is the constant
# `Nil{}` past zero. `drop_drop` fails at its own step case, where dropping `m`
# from nothing is nothing and dropping `n + m` from the list is not, and
# `take_drop` fails wherever `drop` is non-empty. Measured: `proof_tier=3
# bare_tier=2`, `take_len` proven, first failure at `LAWS.take_drop`.
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
      Nil{}
