import Base

# Immutable, and owned by the task rather than the policy. `max_gap` is what the
# policy implements; `absdiff` is the distance the step is folded with, and
# `same` is the list of equal elements the law with content is stated over.

# The distance between two numbers, which is `0n` exactly when they are equal.
# It steps one successor off each side at once, so on two variables it is stuck
# and a law cannot compute one: that a number is at distance `0n` from itself is
# an induction, which is what the law about a run of equal elements turns on.
def absdiff(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n + bp
    case 1n+ap 0n:
      1n + ap
    case 1n+ap 1n+bp:
      absdiff(ap, bp)

# A list of `n` copies of `k`. It is what the law about a run of equal elements
# is stated over: every neighbouring pair in it is at distance `0n`, so the
# largest gap over it is `0n` however long it is. It is not used by the policy,
# only by that law and its proof.
def same(n: Nat, +k: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+np:
      k <> same(np, k)
