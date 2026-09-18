import Base
import ./prelude.bend as P

# The one-element case keeps its element: the last element is treated as part of
# the answer rather than as the thing the answer stops before. Rejected by
# `init_single`, which is definitional -- the body reduces the left-hand side to
# `h <> Nil{}` where the law wants `Nil{}` -- and by `init_snoc` at the empty
# `xs`, where the input is the one-element list `x <> Nil{}` and the body
# answers that element back where the law wants `Nil{}`.
def init(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          h <> Nil{}
        case h2 <> t2:
          h <> init(h2 <> t2)
