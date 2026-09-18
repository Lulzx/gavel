import Base
import ./prelude.bend as P

def is_pal(+xs: List<&2, Nat>) -> Bool:
  P.eq_list(xs, P.rev(xs))
