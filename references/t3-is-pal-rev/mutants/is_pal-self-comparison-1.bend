import Base
import ./prelude.bend as P

# Compares the list with itself instead of with its reverse, which is `True{}`
# of every list. The two pins hold, and `is_pal_rev` holds because `P.rev`
# changes neither side of the comparison, so the same law catches this one as
# catches the constant body: the two-element list of distinct elements.
def is_pal(+xs: List<&2, Nat>) -> Bool:
  P.eq_list(xs, xs)
