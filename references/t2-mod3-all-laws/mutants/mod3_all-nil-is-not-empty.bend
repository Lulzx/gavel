import Base
import ./prelude.bend as P

# The base case answered with a one-element list instead of the empty one: a
# stray element where the map should have none. Rejected by `mod3_all_single`,
# whose left-hand side reduces to `P.mod3_all(Nil{})`, which is `1n <> Nil{}`,
# where the law wants `P.mod3(h) <> Nil{}`. `mod3_all_append` fails too, at the
# empty `xs`: the law's left-hand side is `mod3_all(ys)`, a match on the
# variable `ys` with `1n` consed on in both of its cases, and its right-hand
# side is `1n <> mod3_all(ys)`.
def mod3_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      1n <> Nil{}
    case h <> t:
      P.mod3(h) <> mod3_all(t)
