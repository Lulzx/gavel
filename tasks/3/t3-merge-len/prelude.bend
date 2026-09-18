import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `merge` and the helper its
# recursion goes through.

# `le` compares by matching on its first argument and then on its second, and
# answers with a `Bool`. A `Bool` the recursion computes is not something a
# `match` can reach, which is why the policy needs a helper that takes the
# decision as a parameter.
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

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the work below to the induction rather
# than to the unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
