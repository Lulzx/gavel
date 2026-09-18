import Base
import ./prelude.bend as P

# The off-by-one in the base case: zero steps are taken to mean "the list
# without its head". Every positive count still behaves, so `drop_succ` holds of
# this body -- `drop(1n + k, h <> t)` is `drop(k, t)` on both sides -- and it is
# `drop_append_len` that rejects it, at the empty `xs`: the law asks for `ys`
# where the body answers the tail of `ys`.
def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          t
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          drop(k, t)
