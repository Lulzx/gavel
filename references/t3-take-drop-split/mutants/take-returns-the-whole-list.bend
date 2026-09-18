import Base

# The count is ignored: any non-zero count returns the list itself. This is the
# body `take_drop`'s comment names (with `S.take` returning `xs` the left-hand
# side is `P.append(xs, S.drop(n, xs))`, and `P.append` does not reduce on a
# variable), and `take_len` fails with it as soon as `n` exceeds the length.
# Measured: `proof_tier=3 bare_tier=2`, `drop_drop` proven, first failure at
# `LAWS.take_drop`.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      xs

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
