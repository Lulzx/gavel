import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the two comparisons the walk folds an element
# with, the decision taken on one of them, and the list of equal elements the
# last law is about.

# `gt(a, b)` is `True{}` exactly when `a` is strictly greater than `b`. It
# matches on both arguments at once and steps one successor off each side, so
# with two variables it is stuck and a law cannot compute one. That is why the
# laws below are about the policy's own walk rather than about this.
def gt(a: Nat, b: Nat) -> Bool:
  match a b:
    case 0n 0n:
      False{}
    case 0n 1n+bp:
      False{}
    case 1n+ap 0n:
      True{}
    case 1n+ap 1n+bp:
      gt(ap, bp)

def max2(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n + bp
    case 1n+ap 0n:
      1n + ap
    case 1n+ap 1n+bp:
      1n + max2(ap, bp)

# One of two answers, taken on a decision. It matches on its *parameter*, which
# is why the walk can be written without matching on a computed value: the
# comparison is handed to this function rather than scrutinised where it is
# made.
def pick_if(b: Bool, x: Nat, y: Nat) -> Nat:
  match b:
    case True{}:
      x
    case False{}:
      y

# A list of `n` copies of `k`. It is what the last law is stated over: every
# element of it ties with every other, so the walk has to keep the position it
# started from and no other, whatever the comparison does. It is not used by the
# policy -- only by that law and its proof.
def same(n: Nat, +k: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+np:
      k <> same(np, k)
