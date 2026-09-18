import Base

# Immutable, and owned by the task rather than the policy. `count` is what the
# policy implements; `append` and `is_eq` are here because the laws are stated
# in terms of them.

# `append` matches on its first argument, so `append(count(..), ..)` -- and any
# count of an append -- does not reduce until the left list is a cons.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# `1n` when the two numbers are equal and `0n` otherwise, by structural descent
# on both. It returns a `Nat` rather than a `Bool` because the count below adds
# these up, and adding is what the laws are about.
def is_eq(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      match b:
        case 0n:
          1n
        case 1n+q:
          0n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          is_eq(p, q)
