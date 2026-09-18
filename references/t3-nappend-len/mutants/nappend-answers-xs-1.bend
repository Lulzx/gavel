import Base
import ./prelude.bend as P

# Answers the list itself on every successor: the repetition never happens, the
# recursion is dropped, and `n` is ignored past its shape. This is the body the
# step law names. It type-checks and the zero case is the reference's, so
# `nappend_zero` holds; `nappend_succ` is the law that rejects it, wanting
# `P.append(xs, S.nappend(xs, p))` where this computes to `xs`.
def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      xs
