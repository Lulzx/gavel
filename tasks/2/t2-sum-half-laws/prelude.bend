import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `half`, so the policy's `sum_half` may lean on
# both. `half` is `Nat`-valued rather than `Bool`, so the law's right-hand side
# is an arithmetic term.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# Integer division by two, flooring. It steps two at a time, so it answers on
# `0n`, on `1n`, and on any larger odd number by dropping two.
def half(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+0n:
      0n
    case 1n+1n+p:
      1n + half(p)
