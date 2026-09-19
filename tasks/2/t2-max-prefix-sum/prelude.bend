import Base

# Immutable, and owned by the task rather than the policy. The lists are `Base`'s
# `List<&2, Nat>`, which is `Data`, so a binder may be declared reusable. What
# the laws are stated in -- the comparison the walk folds its running best with
# -- is here.

# `max2(a, b)` is the larger of two numbers. It matches on both arguments at
# once and steps one successor off each side, so with a variable it is stuck and
# a law cannot compute one; on two numerals it reduces to the larger.
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
