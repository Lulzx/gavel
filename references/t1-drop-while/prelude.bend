import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: `le` is the predicate the walk is driven by, and
# `drop_put` is the cons step with the decision exposed as an argument.

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

# `drop_put(h, t, r, k)` is `r` when `k` is `True{}`, and `h <> t` otherwise.
# It is the cons step of `drop_while` with the decision passed in, and it takes
# the head and the tail as well as the recursion's answer because the step that
# stops has to hand the whole list back from where it stopped.
def drop_put(h: Nat, t: List<&2, Nat>, r: List<&2, Nat>, k: Bool) -> List<&2, Nat>:
  match k:
    case True{}:
      r
    case False{}:
      h <> t
