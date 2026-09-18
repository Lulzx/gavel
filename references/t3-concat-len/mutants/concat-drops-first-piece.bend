import Base
import ./prelude.bend as P

# The recursion is written but the piece it was called on is not put back: the
# body flattens the tail and forgets the head. It is the mirror of the
# `Nil{}`-everywhere body the length law's comment names, and it is caught the
# same way -- `concat_len` wants `len(h) + sum_lens(t)` where the left side is
# `sum_lens(t)` alone. `concat_single` sees it definitionally too:
# `concat(xs <> Nil{})` is `concat(Nil{})`, which is `Nil{}` rather than `xs`.
def concat(xss: List<List<Nat>>) -> List<Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      concat(t)
