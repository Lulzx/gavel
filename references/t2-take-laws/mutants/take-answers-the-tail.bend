import Base
import ./prelude.bend as P

# The step answers the tail, which is `drop`'s move written into `take`: the
# head is stepped over instead of kept. `take_succ` rejects it -- the law's
# left-hand side is `h <> take(k, xs)` and the body's answer starts at the second
# element -- and `take_append_len` rejects it too, since at `xs = 1n <> Nil{}`
# the body answers `Nil{}` where the law wants `1n <> Nil{}`.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          t
