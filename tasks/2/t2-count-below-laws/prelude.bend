import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the comparison the two counts are split by, the
# two cons steps with the decision exposed, and the length of a list.

# `le(a, b)` is `True{}` when `a` is at most `b`. It steps one successor off
# each side at once, so it is stuck on a variable and the cons laws below carry
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

# The cons step of `count_below`, with the decision exposed as an argument: a
# `match` cannot scrutinise the computed `le(h, x)`, so the count recurses on
# the list and defers the decision to here.
def cb_put(r: Nat, k: Bool) -> Nat:
  match k:
    case True{}:
      1n + r
    case False{}:
      r

# The same for `count_above`: the two helpers differ in which answer of the
# comparison adds the one.
def ca_put(r: Nat, k: Bool) -> Nat:
  match k:
    case True{}:
      r
    case False{}:
      1n + r

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
