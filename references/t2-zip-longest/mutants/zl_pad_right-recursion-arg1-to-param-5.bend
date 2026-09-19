import Base
import ./prelude.bend as P

# The walk for the case where the second list still has elements and the first
# has run out: every element of `ys` is paired with the padding value on its
# left. It is a separate function rather than a branch of `zip_longest` because
# a recursive call is only accepted when the argument it matches on is the one
# that shrinks, and `zip_longest(Nil{}, t, d)` shrinks the *second* argument:
# splitting the padding off keeps every self-call shrinking the first.
def zl_pad_left(ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkPair{d, h} <> zl_pad_left(t, d)

# The same walk for the other side: `xs` still has elements and `ys` has run
# out, so every element of `xs` is paired with the padding value on its right.
def zl_pad_right(xs: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkPair{h, d} <> zl_pad_right(t, xs)

# The answer: step on the first list and then on the second. While both have
# elements the two heads are packed together and the walk continues; when one
# runs out the other is padded out to the end, on the side it was left short.
def zip_longest(xs: List<&2, Nat>, ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      zl_pad_left(ys, d)
    case hx <> tx:
      match ys:
        case Nil{}:
          P.MkPair{hx, d} <> zl_pad_right(tx, d)
        case hy <> ty:
          P.MkPair{hx, hy} <> zip_longest(tx, ty, d)
