import Base
import ./prelude.bend as P

# The decision handed to the *next* call is computed from the wrong pair of
# heads: the right head that was just emitted is compared against the right
# head of the pair instead of the left one. Nothing is dropped and nothing is
# reordered relative to the two lists, so every law in this set holds of it --
# they are all order-blind and the pins reach only the empty-list
# configurations. Measured: it is rejected anyway, at the hypothesis of
# `Policy.merge_go_len`, because that helper is stated at the reference's own
# decision term (`P.le(hx2, hy2)`) and this body calls it with `P.le(hx, hy)`.
# So read this file as evidence about `merge_len`'s proof obligation, not as
# evidence that a law sees the reordering: the ordering of a merge is another
# task's law, not this one's.
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
              hy <> merge_go(tx, hx, ty2, hy2, P.le(hx, hy))

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
