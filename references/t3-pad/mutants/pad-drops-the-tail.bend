import Base

# The cons case keeps the head and then pads onto nothing instead of onto the
# tail, so every list is truncated to its first element and filled out from
# there. `pad_nil` holds and `pad_single` holds; the length law fails at any
# list of two or more, where the head is counted and the rest is discarded.
# Measured: `proof_tier=3 bare_tier=2`, `pad_nil` and `pad_single` proven,
# first failure at `LAWS.pad_len`.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          x <> pad(k, x, Nil{})
        case h <> t:
          h <> pad(k, x, Nil{})
