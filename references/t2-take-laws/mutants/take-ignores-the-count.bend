import Base
import ./prelude.bend as P

# The cons case hands back the list it was given, so the count is only obeyed by
# the base case. `take_succ` rejects it: at `k = 0n` the law's right-hand side is
# `h <> take(0n, xs)`, which is `h <> Nil{}`, where its left-hand side is
# `h <> xs`, and the two differ as soon as `xs` is non-empty. `take_append_len`
# rejects it too: on the diagonal the body keeps all of `xs <> ys` where the law
# wants `xs` alone.
def take(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          h <> t
