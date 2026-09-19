import Base

# Immutable, and owned by the task rather than the policy. The one thing here is
# the comparison the two decisions are taken from.
#
# `le(a, b)` is `True{}` when `a` is at most `b`. It steps one successor off
# each side at once, so it is stuck on a variable: it is a decision a caller can
# only *take* on values, never case-split on where it is written. It is exposed
# rather than inlined into the task because the two decisions the target takes
# are `P.le(x, lo)` and `P.le(hi, x)`, and both are named in the prompt.
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
