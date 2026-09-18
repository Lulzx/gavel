import Base
import ./prelude.bend as P

# One branch of the step -- left list exhausted, decision `True`, right list
# still carrying a head -- emits the left head and the right tail but loses the
# right head it was holding. A one-head loss in one of eight branches is
# exactly what a careful-looking recursion gets wrong, and it is invisible to
# the pins: no empty-list or single-comparison law reaches this branch.
# Measured: rejected at `Policy.merge_go_len` (`2n + len(ty2)` expected against
# `3n + len(ty2)` observed), and all five laws are left unproven -- the lost
# head shows up in the length law's induction before it reaches the law
# statement.
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
              hx <> hy2 <> ty2
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
