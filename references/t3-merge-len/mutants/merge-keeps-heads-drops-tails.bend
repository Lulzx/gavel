import Base
import ./prelude.bend as P

# `merge` keeps the two heads and drops both tails -- the body a policy writes
# when it has understood that a merge emits the two heads but not that the
# recursion continues. Every pin above it holds (`merge_go` is untouched and
# still correct, `merge_nil_l` and `merge_nil_r` are unaffected), and the
# result is still sorted, so nothing order-sensitive sees it either. `merge_len`
# is the law it fails: `len(hx <> hy <> Nil{})` is `2n` where the law wants
# `len(xs) + len(ys)`.
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
          hx <> tx
        case +hy <> ty:
          hx <> hy <> Nil{}
