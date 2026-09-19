import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the factorial of nothing is one. It is a pin: it fixes the answer on the
# arm the recursion stops at, which no other law here reaches, and it is the
# only law whose argument is the literal `0n`. Alone it pins nothing -- the
# constant body `1n` satisfies it -- so it is here with the step below.
law fact_zero:
  {S.fact(0n) == 1n : Nat}

# LAW: a successor is itself times the factorial of its predecessor. It is
# definitional, and it is the law with the content: the pin above fixes the arm
# where the loop has stopped and says nothing about what happens before it
# stops, and this one fixes the step at a variable argument. A body that
# multiplied by the predecessor instead of the successor, or that dropped the
# recursive call and answered `Nat.mul(1n + n, 1n)`, has the right answer on the
# pin and fails here.
law fact_succ:
  for n: Nat
  {S.fact(1n + n) == Nat.mul(1n + n, S.fact(n)) : Nat}

# LAW: a closed value. The two laws above determine `fact` completely -- a
# function with `g(0n) == 1n` and `g(1n + n) == Nat.mul(1n + n, g(n))` is the
# factorial by induction -- and this one fixes what they compute at a point
# where both sides are literals, so the checker evaluates them rather than
# unfolding anything: five factorial is one hundred and twenty. It is the only
# law whose two sides are both numbers, so it is the one that says the answer is
# that product rather than some other function with the same recurrence.
law fact_five:
  {S.fact(5n) == 120n : Nat}
