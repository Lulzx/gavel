import Base

# Immutable, and owned by the task rather than the policy. `rotate` is what the
# policy implements; `append` is here because the laws are stated in terms of
# it.

# `xs` followed by `ys`. One rotation to the left is the tail followed by the
# head, so the step of `rotate` is stated with this rather than with a cons.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
