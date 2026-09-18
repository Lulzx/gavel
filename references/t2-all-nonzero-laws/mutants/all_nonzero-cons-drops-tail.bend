import Base
import ./prelude.bend as P

# A body a person would plausibly write: the cons cell answers with its head's
# test alone, as if the question were about one element rather than about the
# list. Rejected by `all_nonzero_snoc`: the law asks for the tail's answer to be
# conjoined in, and this body never forms it.
def all_nonzero(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      P.is_nonzero_b(h)
