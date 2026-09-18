import Base
import ./prelude.bend as P

# Every pair comes out the wrong way round: `hy <> hx` where the reference has
# `hx <> hy`. This body reached tier 4 -- full reward -- before `interleave_pair`
# existed, because `interleave_nil_l`/`interleave_nil_r` only ever reach a list
# that is empty on one side and `interleave_len` counts elements rather than
# reading them, so no law in the set constrained the order of a pair. Measured:
# bare tier 2, killed first at `LAWS.interleave_pair`.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case hx <> tx:
      match ys:
        case Nil{}:
          hx <> tx
        case hy <> ty:
          hy <> hx <> interleave(tx, ty)
