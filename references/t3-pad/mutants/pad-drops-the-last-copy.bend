import Base

# The short case recurses without spending a copy on the element, so the pad
# always falls one short of the target: `pad(1n, x, Nil{})` is `Nil{}` and not
# `x <> Nil{}`. `pad_single` contradicts it directly; `pad_nil` holds, so this
# body is the one that shows the single law is not implied by the nil law.
# Measured: `proof_tier=3 bare_tier=2`, `pad_nil` proven, first failure at
# `LAWS.pad_single`.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          pad(k, x, Nil{})
        case h <> t:
          h <> pad(k, x, t)
