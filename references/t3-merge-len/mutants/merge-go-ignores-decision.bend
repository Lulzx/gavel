import Base
import ./prelude.bend as P

# The single-comparison base of `merge_go` answered the same way for both
# values of the decision: the two heads are emitted left-then-right whatever
# `k` says, so the decision is still consumed but no longer read. Both length
# laws and both empty-list laws hold, because nothing was dropped and nothing
# was reordered relative to the lists -- only the comparison was ignored.
# `merge_go_false` is the law that sees it.
def merge_go(+tx: List<&2, Nat>, +hx: Nat, +ty: List<&2, Nat>, +hy: Nat, k: Bool) -> List<&2, Nat>:
  match tx:
    case Nil{}:
      match ty:
        case Nil{}:
          match k:
            case True{}:
              hx <> hy <> Nil{}
            case False{}:
              hx <> hy <> Nil{}
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
          hx <> tx
        case +hy <> ty:
          merge_go(tx, hx, ty, hy, P.le(hx, hy))
