import Base
import ./prelude.bend as P

# `zip_with` answers `h1 <> Nil{}` when it is the *second* list that runs out.
#
# `zip_with_nil_left` forces the answer on the empty first list, but with a
# variable `xs` the outer match is stuck and the law says nothing, so the inner
# empty case is only reached by the induction in `zip_with_nil_right`. The
# generated corpus rewrites steps, not answers, and this is an answer. It is the
# reference with that one case given a non-empty answer, so it type-checks and
# every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `zip_with_len`, `zip_with_nil_right`. `zip_with_cons` is untouched: its two
# inputs are cons cells, so the inner empty case is never reached.
def zip_with(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          h1 <> Nil{}
        case h2 <> t2:
          P.max(h1, h2) <> zip_with(t1, t2)
