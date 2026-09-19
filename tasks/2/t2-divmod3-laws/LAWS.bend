import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing to divide answers a zero quotient and a zero remainder. This is
# definitional -- the match on `0n` answers without recursing -- and it is a
# pin: it fixes the answer on the smallest input, which no other law here
# reaches.
law divmod3_zero:
  {S.divmod3(0n) == P.MkPair{0n, 0n} : P.Pair}

# LAW: one is a zero quotient with a remainder of one. Definitional, and the
# second of the three pins: the step law below is stated at `3n + k`, so a body
# that answered `P.MkPair{0n, 0n}` here would satisfy it, and this law is what
# separates that body from a division.
law divmod3_one:
  {S.divmod3(1n) == P.MkPair{0n, 1n} : P.Pair}

# LAW: two is a zero quotient with a remainder of two. The third pin, for the
# same reason as the two above: the input where the remainder is largest is not
# reached by the step law or by either of the other pins.
law divmod3_two:
  {S.divmod3(2n) == P.MkPair{0n, 2n} : P.Pair}

# LAW: the step. Three more than an input fits one more time, so the quotient
# goes up by one and the remainder is unchanged. Both sides compute, so this is
# definitional, and it is the law that says which way the answer grows: a body
# that counted the threes in a place the recursion does not reach -- or that
# added to the remainder instead of the quotient -- leaves the two sides
# unconvertible here.
law divmod3_succ3:
  for +k: Nat
  {S.divmod3(3n + k) == P.shift(S.divmod3(k)) : P.Pair}

# LAW: the remainder is always below the divisor. This is the law that is not
# definitional: with `n` a variable the two sides do not compute, and the
# induction is the proof. It is the law that says the answer is a *division*
# rather than any pair with the right quotient -- every law above fixes which
# quotient comes out and says nothing about how large the remainder is allowed
# to be, and a body that carried the input through as the remainder satisfies
# them all.
law divmod3_rem:
  for +n: Nat
  {Nat.is_lt(P.snd(S.divmod3(n)), 3n) == True{} : Bool}
