import Base
import ./prelude.bend as P

# The walk gives up after one element: `0n` reads the head exactly as the
# reference does and `1n + p` answers `None{}` on a cons without recursing. The
# first element law holds, the out-of-range law holds -- nothing is claimed to
# be `Some{}` -- and it is `nth_succ` that rejects it: the step has to hand the
# tail to the recursive call, and here the two sides are `None{}` and whatever
# the tail has at `p`. `nth_some` rejects it as well, on the same lists, which
# is the pair doing its job: `nth` is not allowed to be partial inside its own
# domain.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{h}
    case 1n+p:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          None{}
