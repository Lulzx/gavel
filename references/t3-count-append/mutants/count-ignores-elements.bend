import Base
import ./prelude.bend as P

# Every element counts: the indicator is replaced by `1n`, so the body counts
# the length of the list. It is the body that a task stated only through
# `count_nil` and `count_append` would pay for -- both hold of it, and the
# append law is exactly length-additivity -- which is the reason `count_self`
# is in the law set. Measured: rejected at `LAWS.count_cons`, the definitional
# law that wants the indicator of the head in place of the constant.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + count(x, t)
