import Base
import ./prelude.bend as P

# The head's indicator alone, with the recursion written but its result
# discarded -- the first of the two bodies `count_cons`'s comment names. A
# one-element list is answered correctly, so `count_self` holds; the cons law
# fails definitionally at a variable `t` (the law wants `is_eq(x, h) +
# count(x, t)`, and `count(x, t)` is opaque here rather than `0n`), and
# `count_append` fails with it.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      P.is_eq(x, h)
