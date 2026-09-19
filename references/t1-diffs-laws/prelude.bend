import Base

# Immutable, and owned by the task rather than the policy. `diffs` is what the
# policy implements; subtraction is here because the laws are stated in terms of
# it, and because it is the operation a difference is made of.
#
# `sub` is truncated subtraction: it stops at zero instead of going below it.
# Both arguments are matched at once, so with a variable first argument the goal
# does not reduce until something splits on it.
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

# How many elements a list has. The length law is stated in terms of it, so the
# policy's `diffs` may lean on it.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
