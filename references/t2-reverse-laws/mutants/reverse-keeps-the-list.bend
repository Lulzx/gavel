import Base
import ./prelude.bend as P

# The identity body: the two binders are rebuilt as they were found, so the list
# comes back unchanged. It does satisfy `reverse_single` -- at `h <> Nil{}` the
# body answers `h <> Nil{}` -- and `reverse_snoc` is what rejects it: at the cons
# step the body's answer is `snoc(xs, x)` where the law wants `x <> reverse(xs)`,
# and those are different lists as soon as `xs` is non-empty.
def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> t
