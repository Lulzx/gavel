import Base
import ./prelude.bend as P

# The step recurses on the tail without keeping the head, so one element goes
# missing per step. `take_succ` rejects it: the law's left-hand side keeps the
# head in front of the smaller answer and the body's answer does not, and the two
# differ even at `k = 1n`, where the body answers `Nil{}`. `take_append_len`
# rejects it too.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          take(k, t)
