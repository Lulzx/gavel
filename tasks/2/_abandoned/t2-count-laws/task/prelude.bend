import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `eq`, so the policy's `count` may lean on both.
# `eq` is `Nat`-valued rather than `Bool`, so the law's right-hand side is an
# arithmetic term.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def eq(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      1n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      eq(ap, bp)
