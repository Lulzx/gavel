import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: zero compared with zero is `Eq`. Both sides compute, so this one is
# definitional, and it is a pin: it fixes one leaf of the outer match, and no
# other law here is stated at two literal zeroes.
law cmp_zero_zero:
  {S.cmp(0n, 0n) == P.Eq{} : P.Tri}

# LAW: zero is below every successor. Definitional, and the pin on the `Lt`
# leaf: the step law below names `1n + a` on the left as well, so it never
# reaches the answer zero gives against a successor.
law cmp_zero_succ:
  for k: Nat
  {S.cmp(0n, 1n + k) == P.Lt{} : P.Tri}

# LAW: every successor is above zero. The mirror of the law above, and the pin
# on the `Gt` leaf.
law cmp_succ_zero:
  for k: Nat
  {S.cmp(1n + k, 0n) == P.Gt{} : P.Tri}

# LAW: the step. Two successors answer what is below them answers. This is the
# only law that relates `cmp` at one pair of numbers to `cmp` at another pair,
# and with the three pins above it fixes the answer everywhere: the pins give
# the three leaves, and this gives the recursion that reaches every other pair.
law cmp_succ_succ:
  for +a: Nat
  for +b: Nat
  {S.cmp(1n + a, 1n + b) == S.cmp(a, b) : P.Tri}

# LAW: a number compared with itself is `Eq`. This is the work: with `a` a
# variable neither side reduces, so the induction is the proof. It is what a
# body that answered `Lt{}` everywhere cannot satisfy -- such a body keeps the
# step law above, since it steps both sides to the same answer, and every pin
# except this one.
law cmp_self:
  for +a: Nat
  {S.cmp(a, a) == P.Eq{} : P.Tri}

# LAW: the comparison is antisymmetric: comparing `a` with `b` answers what
# comparing `b` with `a` answers with below and above exchanged. This is the
# interaction between the two argument positions -- the only law here whose two
# sides both call `cmp`, at the two orders of the same pair -- and it is the
# only one that uses `P.flip`. The other laws all step both arguments down at
# once; this one is what says the answer depends on which side the smaller
# number is on.
law cmp_antisym:
  for +a: Nat
  for +b: Nat
  {S.cmp(a, b) == P.flip(S.cmp(b, a)) : P.Tri}
