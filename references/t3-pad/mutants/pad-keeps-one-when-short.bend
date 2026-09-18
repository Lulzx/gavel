import Base

# The short case adds the element once and stops, so a list shorter than the
# target is lengthened by exactly one instead of filled up. `pad_nil` and
# `pad_single` both hold -- this is the definitional pair's blind spot -- and
# the length law is what fails: at `n = 1n + k` with the list empty the count
# stays at one however large `k` is. Measured: `proof_tier=3 bare_tier=2`,
# `pad_nil` and `pad_single` proven, first failure at `LAWS.pad_len`.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          x <> Nil{}
        case h <> t:
          h <> pad(k, x, t)
