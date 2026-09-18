import Base
import ./prelude.bend as P

# The piece and the flattened tail are appended the wrong way round, so the
# pieces come out in reverse order with each piece's own elements intact. The
# length is right -- `len_append` gives the same total whichever operand comes
# first -- and `sum` is unchanged as a *value* too, since addition is
# commutative in the answer if not in the proof: this is the body that needs
# `concat_single`-style reasoning about the answer itself rather than about the
# measures. Killed by `concat_len`, whose step folds a `len` over an `append`
# in the reference's order.
def concat(xss: List<List<Nat>>) -> List<Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(concat(t), h)
