import Base
import ./prelude.bend as P

# The step keeps the head and stops recursing, so a positive count is answered
# with a one-element list. `take_succ` rejects it: at `k = 1n` the law's
# right-hand side is `h <> take(1n, xs)`, which is `h <> (h' <> Nil{})`, where
# its left-hand side is `h <> Nil{}`. `take_append_len` rejects it too, since at
# any list of two or more elements the body is short of the law's answer.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> Nil{}
