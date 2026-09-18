import Base

# The filler is hard-coded: the short case pads with `0n` instead of the value
# the policy was handed. The length law cannot see this -- the count is right --
# and neither can `pad_nil`, so the only law that reaches it is `pad_single`,
# which fixes both the length and the element. Together with `pad_nil` and
# `pad_len` that is the whole law set, which is why this body is worth keeping.
# Measured: `proof_tier=3 bare_tier=2`, `pad_nil` and `pad_len` proven, first
# failure at `LAWS.pad_single`.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          0n <> pad(k, x, Nil{})
        case h <> t:
          h <> pad(k, x, t)
