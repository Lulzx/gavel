import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `sub`, so the policy's `sub_all` may lean on both.
# `sub` matches on both arguments at once, which is why the second law's left
# side is not a computation on a variable `xs`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      sub(ap, bp)
