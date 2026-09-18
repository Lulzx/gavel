import Base

# Immutable, and owned by the task rather than the policy. `sum` is what the
# policy implements; `replicate` and `mul` are here because the laws are stated
# in terms of them.

# `replicate` steps on its count, so the run grows on the right.
def replicate(n: Nat, x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      # `x` is used twice here -- once as the head, once in the recursion -- and
      # a parameter is Lone, so the second use is a linearity error. The prelude
      # is checked whether or not a law calls it, so as written every book in
      # the task failed with a Location inside this file.
      +x2 = x
      x2 <> replicate(k, x2)

# Multiplication, recursing on its first argument, the way Base's own `Nat.mul`
# does. The first law below is about `sum` measured against this function, so
# it is fixed here rather than asked for.
def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      +b2 = b
      b2 + mul(p, b2)
