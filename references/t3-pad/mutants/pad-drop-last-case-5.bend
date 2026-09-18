import Base

# The reference solution: step on the target length, and keep the head when
# there is one. When the list runs out first, the remaining count is spent on
# copies of `x`, which is why the empty case recurses on a `Nil{}` rather than
# on itself -- and why `x` is `+`: the empty case mentions it twice.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          x <> pad(k, x, Nil{})
