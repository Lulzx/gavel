import Base
import ./prelude.bend as P

# The base case answered with a one-element list instead of the empty one: a
# stray element where the cap should have none. Rejected by `min_all_single`,
# whose left-hand side reduces to `P.min_all(Nil{}, n)`, which is
# `1n <> Nil{}`, where the law wants `P.min(h, n) <> Nil{}`. `min_all_append`
# fails too, at the empty `xs`: the law's left-hand side is `min_all(ys, n)`, a
# match on the variable `ys` with `1n` consed on in both of its cases, and its
# right-hand side is `1n <> min_all(ys, n)`.
def min_all(xs: List<Nat>, n: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      +k = n
      P.min(h, k) <> min_all(t, k)
