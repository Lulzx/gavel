import Base
import ./prelude.bend as P

# A body a person would plausibly write: at count `0n` the whole list is counted
# anyway, the slip of reading "the prefix of length n" as "the list". Rejected
# by `count_odd_prefix_zero`, which is definitional: its left-hand side reduces
# to `P.count_odd(xs)` where the law wants `0n`.
def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      P.count_odd(xs)
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          P.is_odd(h) + count_odd_prefix(k, t)
