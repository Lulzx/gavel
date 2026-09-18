import Base
import ./prelude.bend as P

# A body a person would plausibly write: count `0n` answers `1n`, an off-by-one
# in the base case. Rejected by `count_odd_prefix_zero`, which is definitional:
# its left-hand side reduces to `1n` where the law wants `0n`.
# `count_odd_prefix_len` fails on this body too: at the empty case of its
# induction the count is `len(Nil{})`, which is `0n`.
def count_odd_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      1n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          P.is_odd(h) + count_odd_prefix(k, t)
