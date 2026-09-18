import Base
import ./prelude.bend as P

# The empty-left case answers `Nil{}` rather than the right list, so an
# exhausted left side ends the interleaving instead of handing over what is
# left. `interleave_nil_l` fails definitionally -- `Nil{}` against `ys` at a
# variable `ys` -- and `interleave_len` is short by the whole right list. The
# cons cases are the reference's, so nothing else distinguishes it. Measured:
# rejected at `Policy.interleave_len_general`, the length law's helper.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case hx <> tx:
      match ys:
        case Nil{}:
          hx <> tx
        case hy <> ty:
          hx <> hy <> interleave(tx, ty)
