import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no budget left means no steps taken. The left-hand side is a ground term
# in the budget and both sides compute, so this is definitional: it fixes the
# answer the recursion reaches when the walk has run out, and no other law here
# reaches it, because every other law either hands the walk a budget above zero
# or names a number it stops at.
law collatz_len_no_fuel:
  for n: Nat
  {S.collatz_len(0n, n) == 0n : Nat}

# LAW: zero is where the walk stops, and it answers no steps. It is the law that
# fixes what the inner match answers at `0n`, which the step law below never
# reaches -- that one is stated at `1n + 1n + p`. It is a case split on the
# budget rather than a computation, because the outer match has to see the
# budget as a numeral before the inner one is reached.
law collatz_len_zero:
  for f: Nat
  {S.collatz_len(f, 0n) == 0n : Nat}

# LAW: one is the other place the walk stops, and it answers no steps either. It
# is not implied by the law above: `1n` is the other answer the inner match
# gives without recursing, and a body that sent `1n` on to `4n` -- which is what
# one Collatz step does with it -- keeps the law above and fails this one.
law collatz_len_one:
  for f: Nat
  {S.collatz_len(f, 1n) == 0n : Nat}

# LAW: one more unit of budget buys one more step. This is the law with the
# content: it says the walk counts, that a step costs exactly one, and that the
# value it sends the next step to is `Bool.pick` of the parity over `P.half` and
# `3n*n + 1n`. Both sides compute -- the budget is `1n + f` and the number is
# `1n + 1n + p`, so both matches take a step case -- and the step term they are
# left with is the same on both sides. A body that recursed at the same number,
# or that took the odd branch for even numbers, is separated here.
law collatz_len_step:
  for +f: Nat
  for +p: Nat
  {S.collatz_len(1n + f, 1n + 1n + p) == 1n + S.collatz_len(f, Bool.pick(Nat, P.is_even_b(1n + 1n + p), P.half(1n + 1n + p), Nat.mul(3n, 1n + 1n + p) + 1n)) : Nat}

# LAW: one closed value, walked end to end. The laws above fix the recurrence
# and the two answers it stops at; this one fixes what they compute on a number
# the map has to be applied to: `6n` reaches `1n` in eight steps, and `30n` of
# budget is more than enough for them, so the answer is `8n` -- not the number
# of digits, not the number itself.
law collatz_len_six:
  {S.collatz_len(30n, 6n) == 8n : Nat}

# LAW: a longer closed walk. `27n` is the smallest number whose Collatz path is
# long, and it reaches `1n` in `111n` steps.
law collatz_len_twentyseven:
  {S.collatz_len(200n, 27n) == 111n : Nat}
