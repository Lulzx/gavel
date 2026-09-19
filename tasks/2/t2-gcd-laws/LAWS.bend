import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no budget left answers the divisor found so far. This is a pin: it fixes
# the answer on the first arm of the recursion, which no other law here reaches,
# because every other law about `gcd` either hands it a budget or names a
# divisor of `0n`.
law gcd_no_fuel:
  for a: Nat
  for b: Nat
  {S.gcd(0n, a, b) == a : Nat}

# LAW: nothing left to divide by answers `a`. It is the other pin, on the arm
# the step law does not reach, and it is an induction rather than a computation
# because `gcd` cannot look at the budget until it is a numeral.
law gcd_zero_divisor:
  for f: Nat
  for a: Nat
  {S.gcd(f, a, 0n) == a : Nat}

# LAW: one more step of budget buys one step of Euclid -- the divisor becomes
# `a` and the remainder of `a` by that divisor becomes the new divisor. It is
# definitional, and it is the law with the content: the two pins above fix only
# the arms where the loop has already stopped, and this one fixes what a body
# has to do before it stops. A body that stepped the wrong way -- recursing on
# `a` instead of `b`, or taking the remainder the other way round -- has the
# right answers on both pins and fails here.
law gcd_step:
  for f: Nat
  for a: Nat
  for +b: Nat
  {S.gcd(1n + f, a, 1n + b) == S.gcd(f, 1n + b, Nat.mod(a, 1n + b)) : Nat}

# LAW: a closed value. The three laws above fix `gcd` at every shape of
# argument, and this one fixes what they all compute: the greatest common
# divisor of twelve and eighteen is six. It is the only law whose two sides are
# both numbers, so it is the one that says the answer is the divisor rather than
# something with the same recurrence.
law gcd_twelve_eighteen:
  {S.gcd(30n, 12n, 18n) == 6n : Nat}
