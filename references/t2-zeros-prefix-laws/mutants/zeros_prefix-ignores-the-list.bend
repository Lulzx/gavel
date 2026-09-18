import Base
import ./prelude.bend as P

# The count is walked but the list is not counted: the step hands back the count.
# `zeros_prefix_zero` holds -- the count reaches zero before the list is looked at
# -- and `zeros_prefix_len` is what rejects it: on the diagonal the law wants the
# number of zeros in the list and the body answers `len(xs)`, which is `1n` at
# `2n <> Nil{}` where the law wants `0n`.
def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          1n+k
