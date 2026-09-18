import Base

# Immutable, and owned by the task rather than the policy. `sum` is what the
# policy implements; `replicate` and `mul` are here because the laws are stated
# in terms of them.

# `replicate` steps on its count, so the run grows on the right. Both of its
# arguments are needed more than once -- the element is the head and also the
# argument to the recursion -- so both are marked `+`, which is how a parameter
# says it may be used more than once.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> replicate(k, x)

# Multiplication, recursing on its first argument, the way Base's own `Nat.mul`
# does. The first law below is about `sum` measured against this function, so
# it is fixed here rather than asked for; `b` is `+` for the same reason.
def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      b + mul(p, b)
