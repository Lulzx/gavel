import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: `le` is the predicate the walk is driven by, and
# `count_put` is the cons step with the decision exposed as an argument.

# `le(a, b)` is `True{}` when `a` is at most `b`. It steps one successor off
# each side at once, so it is stuck on a variable and the two laws below carry
# its answer as a premise rather than computing it.
def le(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      True{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          le(p, q)

# `count_put(c, k)` is `1n + c` when `k` is `True{}`, and `0n` otherwise. It is
# the cons step of `count_while` with the decision passed in, and the head is
# not one of its arguments because a count does not carry the element: the
# helper is what the step *does* with the predicate's answer, nothing more.
def count_put(c: Nat, k: Bool) -> Nat:
  match k:
    case True{}:
      1n + c
    case False{}:
      0n
