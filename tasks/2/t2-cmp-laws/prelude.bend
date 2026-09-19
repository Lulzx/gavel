import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; `cmp` is what the policy writes.

# The three answers a comparison of two numbers can give. Bend has no
# enumerations, so the answer is a data type of its own, the way the pair in a
# two-list task is.
type Tri is Data:
  Lt{}
  Eq{}
  Gt{}

# `flip(t)` is the answer for the same two numbers the other way round: below
# becomes above and above becomes below. It is here rather than in the policy
# so that the antisymmetry law below is about `cmp` and not about two functions
# the policy could define to match each other.
def flip(t: Tri) -> Tri:
  match t:
    case Lt{}:
      Gt{}
    case Eq{}:
      Eq{}
    case Gt{}:
      Lt{}
