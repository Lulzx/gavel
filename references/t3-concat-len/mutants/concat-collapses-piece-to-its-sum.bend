import Base
import ./prelude.bend as P

# Each piece is replaced by its sum as a single element: the body keeps the
# order and the recursion, and it reads the piece through the prelude's own
# measure. Read the three laws against it. `concat_len` fails as soon as a
# piece has more than one element (one element emitted where `len(h)` are
# wanted), and `concat_single` fails definitionally -- `sum(xs) <> Nil{}`
# against `xs`. `concat_sum` is the interesting one: the *statement* is true of
# this body, because the sum of the answer is `sum(h) + sum_sums(t)` either way.
# Measured: the checker rejects it at `LAWS.concat_len` and reports all three
# laws unproven, so this file is evidence for the two laws that see the body and
# not for `concat_sum`, whose content no body of this shape can move.
def concat(xss: List<List<Nat>>) -> List<Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(P.sum(h) <> Nil{}, concat(t))
