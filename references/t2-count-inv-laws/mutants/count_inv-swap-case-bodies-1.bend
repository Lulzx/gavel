import Base
import ./prelude.bend as P

# The reference solution: recurse on `xs`, and at a cons cell count the elements
# of the tail that are below the head and add the tail's own count. The tail is
# read by both the prelude's count and the recursive call, so the pattern marks
# it reusable; the head is read once.
def count_inv(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.count_gt(h, t) + count_inv(t)

    case h <> +t:
      0n
