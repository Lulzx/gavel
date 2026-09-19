import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a count of zero enumerates nothing. Both sides compute, so this one is
# definitional, and it is the weak companion that pins the base case:
# `enum_from_succ` names only a successor count, so on its own it is satisfied
# by a body that answers a non-empty list at `0n`.
law enum_from_zero:
  for a: Nat
  {S.enum_from(0n, a) == Nil{} : List<Nat>}

# LAW: the step, and the law that says where the run starts and how it advances.
# Both sides compute, so this is definitional: a run of `1n+k` numbers starting
# at `a` is `a` in front of a run of `k` numbers starting at `1n+a`. It is what
# rules out a body that repeated one number, or that advanced by two, since both
# of those leave the two sides unconvertible for a variable `a` and `n`.
law enum_from_succ:
  for n: Nat
  for a: Nat
  {S.enum_from(1n + n, a) == a <> S.enum_from(n, 1n + a) : List<Nat>}

# LAW: the run has as many elements as were asked for. `len` matches on its
# first argument, so with a variable `n` the goal does not reduce on its own:
# this one is inductive in `n`, and it is what pins the count, which the step
# law above leaves open -- a body that answered a shorter run on each step
# satisfies `enum_from_succ` and contradicts this one.
law enum_from_len:
  for n: Nat
  for a: Nat
  {P.len(S.enum_from(n, a)) == n : Nat}
