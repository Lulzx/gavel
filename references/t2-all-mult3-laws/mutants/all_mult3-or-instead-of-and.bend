import Base
import ./prelude.bend as P

# A body a person would plausibly write: `Bool.or` where `Bool.and` belongs, the
# slip of reading "every element" as "some element". Rejected by
# `all_mult3_snoc`: the law's right-hand side is a conjunction, so at the empty
# case of the induction it is `is_mult3_b(x)`, while this body's left-hand side
# is `Bool.or(..., True{})`, which is `True{}` for every `x`.
def all_mult3(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      Bool.or(P.is_mult3_b(h), all_mult3(t))
