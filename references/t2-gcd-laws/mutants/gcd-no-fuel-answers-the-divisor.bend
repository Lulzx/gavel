import Base
import ./prelude.bend as P

# The reference with the empty-budget arm answering `b` instead of `a`: the
# whole loop is right, and only the answer on the arm the recursion has already
# left is wrong. It is the hand-written evidence for `gcd_no_fuel`, which no
# generated mutant reaches -- the generator rewrites a step, and this arm is an
# answer reached by a match that has stopped. It also fails `gcd_zero_divisor`,
# because a budget of `0n` is the same arm.
# Measured: `proof_tier=3 bare_tier=2`, first failure at `LAWS.gcd_no_fuel`
# (also caught by `LAWS.gcd_zero_divisor`).
def gcd(fuel: Nat, a: Nat, +b: Nat) -> Nat:
  match fuel:
    case 0n:
      b
    case 1n++k:
      match b:
        case 0n:
          a
        case 1n++j:
          gcd(k, b, Nat.mod(a, b))
