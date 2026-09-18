import Base
import ./prelude.bend as P

# The count of the tail alone -- the second of the two bodies `count_cons`'s
# comment names. The head is matched and then never asked about, so the answer
# is `0n` for every list. `count_nil` holds, and `count_cons` fails
# definitionally at a variable `t`: the law's right side is
# `is_eq(x, h) + count(x, t)`, which is not `count(x, t)`. `count_self` fails
# with it.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      count(x, t)
