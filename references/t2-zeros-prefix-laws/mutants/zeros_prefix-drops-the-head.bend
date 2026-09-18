import Base
import ./prelude.bend as P

# The step steps both arguments down but forgets to test the head, so the answer
# counts the zeros of everything after the first element. `zeros_prefix_zero`
# holds -- the head is never reached at count zero -- and `zeros_prefix_len`
# rejects it: at `xs = 0n <> Nil{}` the law wants `P.count_zeros(0n <> Nil{})`,
# which is `1n`, and the body answers `0n`.
def zeros_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      match xs:
        case Nil{}:
          0n
        case h <> t:
          zeros_prefix(k, t)
