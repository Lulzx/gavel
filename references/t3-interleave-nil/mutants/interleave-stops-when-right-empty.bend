import Base
import ./prelude.bend as P

# When the right list runs out, the left list's remainder is dropped instead of
# being emitted: the body stops as soon as the two lists are of different
# lengths. Read at `interleave(xs, Nil{})`: the right side of that law is `xs`
# and this body answers `Nil{}` at a cons, so `interleave_nil_r` fails
# definitionally. `interleave_len` fails with it, one element per leftover.
# Measured: rejected at `Policy.interleave_len_general`, the length law's
# helper, with all three laws reported unproven.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          hx <> hy <> interleave(tx, ty)
