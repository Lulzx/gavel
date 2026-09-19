import Base

# Immutable, and owned by the task rather than the policy. `lcp_len` is what the
# policy implements; everything here is the vocabulary the laws are stated in --
# the comparison that decides whether two elements agree, the gate that turns
# that decision into a length, and the length of a list.

# `is_eq(a, b)` is `1n` when `a` and `b` are equal and `0n` otherwise, by
# structural descent on both. It returns a `Nat` rather than a `Bool` because
# the gate below multiplies with it: a `match` may not scrutinise the result of
# a call, so a `Bool` answer could not be used inside the step.
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

# `gate(c, n)` is `n` when its first argument is non-zero and `0n` when it is
# zero -- the equality test as a length. Both arguments are read once.
def gate(c: Nat, n: Nat) -> Nat:
  match c:
    case 0n:
      0n
    case 1n+p:
      n

# `len(xs)` is the number of elements of `xs`. The head is not read, so it is
# not marked.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
