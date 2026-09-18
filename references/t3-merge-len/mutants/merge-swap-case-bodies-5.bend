import Base
import ./prelude.bend as P

# The step, generalized over both lists and over the decision. The tails are the
# first two arguments -- they carry the list each head came off, so `hx <> tx`
# and `hy <> ty` are the two lists being merged -- and `k`, the already-computed
# `P.le(hx, hy)`, is matched last, because a match consumes the binders in front
# of its scrutinee and nothing may be matched after it. That is why both tails
# are matched *before* `k`: the decision the next call needs is `P.le` of the
# two heads those matches bind, and the head of the side being advanced is not
# available until its tail has been matched.
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

# `merge` only has to make the first decision; every decision after it belongs to
# `merge_go`, which is handed the two tails and the two heads already split.
def merge(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case +hx <> tx:
      match ys:
        case Nil{}:
          merge_go(tx, hx, ty, hy, P.le(hx, hy))

        case +hy <> ty:
          hx <> tx
