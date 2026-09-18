import Base
import ./prelude.bend as P

# The base case answered with a one-element list instead of the empty one -- a
# stray element where the map should have none. Rejected by `dec2_all_single`,
# whose left-hand side reduces to `P.dec2_all(Nil{})`, which is `1n <> Nil{}`,
# where the law wants `P.dec2(h) <> Nil{}`. `dec2_all_append` fails too, at the
# empty `xs`: the law's left-hand side is `dec2_all(ys)`, a match on the
# variable `ys` with `1n` consed on in both of its cases, and its right-hand
# side is `1n <> dec2_all(ys)`.
def dec2_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.dec2(h) <> dec2_all(t)
