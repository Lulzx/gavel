import Base
import ./prelude.bend as P

# The piece and the flattened tail are appended the wrong way round, so the
# pieces come out in reverse order with each piece's own elements intact. The
# length and the sum are right, and a one-piece list cannot tell the order
# apart, so all three original laws accept it. This file used to say it was
# killed by `concat_len`; that was the reference proof's step, which folds `len`
# over an `append` in the reference's order, failing to replay -- a policy proves
# `len_append` the other way round. Rejected by `concat_cons`.
def concat(xss: List<List<Nat>>) -> List<Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(concat(t), h)
