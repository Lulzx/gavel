import Base
import ./prelude.bend as P

# A step read as "take one off the front" applied to the wrong unit: the nested
# match removes two cells per count, so `drop(1n, [1n, 2n, 3n])` is
# `3n <> Nil{}`. Rejected by `drop_succ`, whose left-hand side reduces to a
# match on the tail `t` where its right-hand side is `drop(k, t)` -- with `t` a
# variable the two are not the same term -- and by `drop_append_len`, where the
# count walks off the end of `xs` and leaves the law's `ys` behind.
def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          match t:
            case Nil{}:
              Nil{}
            case h2 <> t2:
              drop(k, t2)
