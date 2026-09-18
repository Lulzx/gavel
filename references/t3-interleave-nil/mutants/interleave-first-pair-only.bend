import Base
import ./prelude.bend as P

# The first pair is emitted correctly and the recursion is written but its
# result is discarded, so the answer is the first two elements. `interleave_nil_l`
# and `interleave_nil_r` are unaffected (both are about a list that is empty on
# one side), and `interleave_len` is the law that fails -- the constant bodies
# in this corpus answer `ys` or `hx <> tx`; this one answers a list whose shape
# still follows the pairing. Measured: rejected at
# `Policy.interleave_len_general`, the length law's helper.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case hx <> tx:
      match ys:
        case Nil{}:
          hx <> tx
        case hy <> ty:
          hx <> hy <> Nil{}
