import Base
import ./prelude.bend as P

# `0n` reads one element too far: on a cons it answers the head of the *tail*
# when there is one, and only falls back to the head on a singleton. It agrees
# with the reference on the list `nth_zero` is easiest to read at -- a one
# element tail-less cons -- which is what makes it worth having: the law is
# quantified over `t` as well as `h`, so any `t` with at least two elements
# separates `Some{h2}` from `Some{h}`. The step law and both domain laws hold;
# `nth_zero` alone rejects it.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          match t:
            case Nil{}:
              Some{h}
            case h2 <> t2:
              Some{h2}
    case 1n+p:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          nth(p, t)
