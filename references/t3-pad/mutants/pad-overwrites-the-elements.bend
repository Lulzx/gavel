import Base

# The length-preserving component swap: every element the caller passed in is
# replaced by the filler, so `pad` returns `n` copies of `x` whatever it was
# handed. This body reached tier 4 -- full reward -- before `pad_step` existed:
# `pad_nil` fixes the zero count, `pad_single` only ever asks about `Nil{}` and
# `pad_len` counts, so no case of the step was constrained. Measured: bare tier
# 2, killed first at `LAWS.pad_step`, which needs `x == y` at variables.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          x <> pad(k, x, Nil{})
        case h <> t:
          x <> pad(k, x, t)
