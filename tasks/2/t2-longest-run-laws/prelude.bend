import Base

# Immutable, and owned by the task rather than the policy. `longest_run_len` is
# what the policy implements; everything here is the vocabulary the laws are
# stated in -- the comparison that decides whether two neighbours agree, the
# gate that turns that decision into a length, and the length of the run that
# starts at a list's first element.

# `is_eq(a, b)` is `1n` when `a` and `b` are equal and `0n` otherwise, by
# structural descent on both. It returns a `Nat` rather than a `Bool` because
# the gate below multiplies with it: a `match` may not scrutinise the result of
# a call, so a `Bool` answer could not be used inside a step.
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
# zero. Both arguments are read once.
def gate(c: Nat, n: Nat) -> Nat:
  match c:
    case 0n:
      0n
    case 1n+p:
      n

# `run_len(xs)` is the length of the block of equal elements that starts at the
# first element of `xs`: `0n` on the empty list, and at least `1n` on any list
# that has a first element. The inner pattern reaches the second element without
# a second match, and the second element is marked reusable because the decision
# reads it and the recursion is handed it.
def run_len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case x <> Nil{}:
      1n
    case h <> (+k <> u):
      1n + gate(is_eq(h, k), run_len(k <> u))
