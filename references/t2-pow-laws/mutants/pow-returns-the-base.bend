import Base

# The base answered in both branches, so the power is the base whatever the
# exponent is: the projection that `pow_one` is written for, reached by never
# writing the multiplication. Rejected by `pow_zero`, whose left-hand side
# reduces to `a` where the law wants `1n`, and by `pow_one`, which is true of
# the body -- `pow(x, 1n)` is `x` here -- and which the proof rejects anyway: the
# checker stops in `L.pow_one`, whose step rewrites with `Policy.mul_one_right`
# and looks for `Nat.mul(x, 1n)` in an answer that does not contain it.
def pow(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      a
    case 1n+p:
      a
