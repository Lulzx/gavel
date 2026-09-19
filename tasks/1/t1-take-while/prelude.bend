import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: `le` is the predicate the walk is driven by, and
# `keep_put` is the cons step with the decision exposed as an argument.

# `le(a, b)` is `True{}` when `a` is at most `b`. It steps one successor off
# each side at once, which is why it is stuck on a variable and why the two
# laws below carry the predicate's answer as a premise rather than computing it.
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

# `keep_put(h, r, k)` is `h <> r` when `k` is `True{}`, and `Nil{}` otherwise.
# It is the cons step of `take_while` factored out so that the decision is an
# argument: a `match` cannot scrutinise a computed value in Bend, so the step
# that has to answer two different ways on `le(h, n)` cannot be written inline.
def keep_put(h: Nat, r: List<Nat>, k: Bool) -> List<Nat>:
  match k:
    case True{}:
      h <> r
    case False{}:
      Nil{}
