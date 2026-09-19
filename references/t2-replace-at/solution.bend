import Base
import ./prelude.bend as P

# The reference solution: step on the count and walk into the list. At `0n` the
# head is dropped and `y` stands in its place, and at `1n + p` the head survives
# and the walk continues on the element behind it. Where the count runs past the
# end the empty list is the answer, so the heads the walk already passed come
# back in front of it and `xs` is unchanged.
def replace_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          y <> t
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> replace_at(p, t, y)
