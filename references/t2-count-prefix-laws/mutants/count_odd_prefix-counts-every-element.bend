import Base
import ./prelude.bend as P

# A body a person would plausibly write: the step adds `1n` for the element
# instead of its oddness test, i.e. counts the prefix rather than the odd
# numbers in it. Rejected by `count_odd_prefix_len`: the law's right-hand side
# is `P.count_odd(xs)`, which leaves an element alone when it is even, and this
# body does not.
def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          1n + count_odd_prefix(k, t)
