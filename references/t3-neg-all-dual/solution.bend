import Base
import ./prelude.bend as P

# The negation lands on the head and the cons stays a cons, so the map keeps
# the order. `h` and `t` are each used once: the list is `List<&2, Bool>`, so
# the tail could be reused if the body needed it, and the laws are what need
# that, not this.
def neg_all(xs: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      Bool.not(h) <> neg_all(t)
