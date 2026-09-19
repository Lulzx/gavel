import Base

# Immutable, and owned by the task rather than the policy. `take_last` is what
# the policy implements; `len`, `le` and `keep_if` are the vocabulary its step
# and its laws are written in.

# The number of elements in a list. It walks the whole list, so on a variable it
# is stuck, and `len(x <> xs)` is `1n + len(xs)` however long `xs` is.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# Whether `a` is at most `b`. It steps one successor off each side at once, and a
# side that is `0n` answers on the spot -- so `le(0n, k)` is `True{}` whatever `k`
# is, and `le(1n + a, 0n)` is `False{}` whatever `a` is, neither of which reduces
# by itself when the other side is a variable.
def le(a: Nat, b: Nat) -> Bool:
  match a b:
    case 0n 0n:
      True{}
    case 0n 1n+bp:
      True{}
    case 1n+ap 0n:
      False{}
    case 1n+ap 1n+bp:
      le(ap, bp)

# `xs` when `b`, `r` otherwise. A `match` cannot scrutinise a call, so the
# decision a step takes is handed to a function that can match on it.
def keep_if(b: Bool, xs: List<&2, Nat>, r: List<&2, Nat>) -> List<&2, Nat>:
  match b:
    case True{}:
      xs
    case False{}:
      r
