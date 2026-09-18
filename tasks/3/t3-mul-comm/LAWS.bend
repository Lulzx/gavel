import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: multiplying by one on the right changes nothing. This is the law that
# rules out every constant body: with `S.mul` returning `0n` the left-hand side
# computes and the right-hand side is the variable `x`, which `{==}` cannot
# prove. The identity body -- `mul(a, b) = a`, the first parameter of the
# return type -- satisfies it, and is ruled out by `mul_zero_right` instead,
# so the two are not redundant.
law mul_one_right:
  for x: Nat
  {S.mul(x, 1n) == x : Nat}

# LAW: multiplying by zero on the right gives zero. It is the other half of the
# constant/identity pair: `{==}` fails here for the identity body, where the
# left-hand side computes to the variable `x` and the right-hand side is `0n`.
law mul_zero_right:
  for x: Nat
  {S.mul(x, 0n) == 0n : Nat}

# LAW: multiplying by a successor on the right is one more copy of the left
# factor. `mul` steps on its *left* argument, so with the right factor a
# variable the goal is stuck, and this is a genuine induction on `x` rather
# than an unfolding. Its step case cannot be closed without moving a successor
# past an addition, which is where the arithmetic helpers come in.
law mul_succ_right:
  for x: Nat
  for y: Nat
  {S.mul(x, 1n + y) == x + S.mul(x, y) : Nat}

# LAW: multiplication commutes. Neither of the two right-factor laws says
# anything about the order of the factors, and `mul_succ_right` alone is
# satisfied by any body that ignores its left argument in the second position,
# so this is the law that pins the order. Its step case unfolds the left factor
# into `b + S.mul(p, b)`, applies the hypothesis to the tail -- which is the
# only place `p` may be used live unless it is rebound -- and then folds the
# right factor back with the successor law. `{==}` proves nothing here: both
# sides are stuck on variables.
law mul_comm:
  for a: Nat
  for b: Nat
  {S.mul(a, b) == S.mul(b, a) : Nat}
