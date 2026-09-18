import Base
import ./prelude.bend as P

# Only one head of each pair is emitted: the right list's head is written and
# the left list's is bound and dropped, so the answer is `ys` interleaved with
# the tails of `xs`. The nil laws hold (the drain case and the empty case are
# the reference's), which is exactly why `interleave_len` is in the set: it is
# short one element per pair, and that is the only law that can see it.
# Measured: rejected at `Policy.interleave_len_general`, the length law's
# helper, with all three laws reported unproven.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case hx <> tx:
      match ys:
        case Nil{}:
          hx <> tx
        case hy <> ty:
          hy <> interleave(tx, ty)
