import Base
import ./prelude.bend as P

# `drop` written as `take`: the count is honoured cell by cell and the cells are
# kept instead of removed, so `drop(2n, xs)` is the first two elements of `xs`.
# The classic inversion of the two functions, and plausible against a stub whose
# prose says which end the elements come off. Rejected by `drop_succ`, whose
# left-hand side reduces to `h <> drop(k, t)` where its right-hand side is
# `drop(k, t)`, and by `drop_append_len`: the body answers the first `len(xs)`
# elements of `xs <> ys`, which is `xs`, where the law wants `ys`.
def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> drop(k, t)
