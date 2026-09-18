import Base
import ./prelude.bend as P

# Every element is counted instead of only the zeros -- `P.is_zero(h)` is left
# out of the step. `zeros_prefix_zero` holds, and `zeros_prefix_len` rejects it:
# at `xs = 1n <> Nil{}` the law wants `P.count_zeros(1n <> Nil{})`, which is
# `0n`, and the body answers `1n`.
def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          1n + zeros_prefix(k, t)
