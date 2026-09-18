import Base

# The prefix has the right length and the wrong elements: every element taken is
# replaced by `0n`. The length law counts and holds; `take_drop` is the law that
# fails, since the first half of the argument is no longer the argument's
# prefix. Measured: `proof_tier=3 bare_tier=2`, `drop_drop` and `take_len`
# proven, first failure at `LAWS.take_drop`.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          0n <> take(k, t)

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
