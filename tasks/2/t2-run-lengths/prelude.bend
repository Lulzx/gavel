import Base

# Immutable, and owned by the task rather than the policy. `run_lengths` is what
# the policy implements; `same` is here because the walk has to answer two
# different ways on a comparison of two elements, and that comparison is not an
# argument of any function.

# Whether two `Nat`s are the same number. It steps one successor off each side at
# once, so with a variable on either side the answer does not reduce: that a
# number is the same as itself is an induction and not an unfolding, which is
# what the law about an element equal to the one in hand turns on.
def same(a: Nat, b: Nat) -> Bool:
  match a b:
    case 0n 0n:
      True{}
    case 0n 1n+bp:
      False{}
    case 1n+ap 0n:
      False{}
    case 1n+ap 1n+bp:
      same(ap, bp)
