import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the two comparisons the walk folds an element
# with.

# `min2` is the smaller of two numbers and `max2` the larger. They match on
# both arguments at once and step one successor off each side, so with a
# variable they are stuck and a law cannot compute one. That is why the laws
# below are about the policy's own walk rather than about these.
def min2(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n + min2(ap, bp)

def max2(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n + bp
    case 1n+ap 0n:
      1n + ap
    case 1n+ap 1n+bp:
      1n + max2(ap, bp)
