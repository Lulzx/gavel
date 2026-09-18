import Base
import ./prelude.bend as P

# The empty-right case of `merge` answered with the empty list instead of the
# left one -- the shape a stub leaves behind when only the first case was
# filled in. `merge_nil_l` holds (`merge(Nil{}, ys)` is still `ys`), so the
# two-sided laws do not see it; `merge_nil_r` does, at `xs = h <> t`.
# `merge_len` fails on the same body.
def merge_go(+tx: List<&2, Nat>, +hx: Nat, +ty: List<&2, Nat>, +hy: Nat, k: Bool) -> List<&2, Nat>:
  match tx:
    case Nil{}:
      match ty:
        case Nil{}:
          match k:
            case True{}:
              hx <> hy <> Nil{}
            case False{}:
              hy <> hx <> Nil{}
        case +hy2 <> ty2:
          match k:
            case True{}:
              hx <> hy <> hy2 <> ty2
            case False{}:
              hy <> merge_go(Nil{}, hx, ty2, hy2, P.le(hx, hy2))
    case +hx2 <> tx2:
      match ty:
        case Nil{}:
          match k:
            case True{}:
              hx <> merge_go(tx2, hx2, ty, hy, P.le(hx2, hy))
            case False{}:
              hy <> hx <> hx2 <> tx2
        case +hy2 <> ty2:
          match k:
            case True{}:
              hx <> merge_go(tx2, hx2, ty, hy, P.le(hx2, hy))
            case False{}:
              hy <> merge_go(tx, hx, ty2, hy2, P.le(hx, hy2))

def merge(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case +hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case +hy <> ty:
          merge_go(tx, hx, ty, hy, P.le(hx, hy))
