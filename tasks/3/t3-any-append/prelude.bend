import Base

# Immutable, and owned by the task rather than the policy. The laws are stated
# over lists of `Bool` and are built from `append`, so both live here and `any`
# is the only thing under test.

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the law about it to the induction.
def append(xs: List<&2, Bool>, ys: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
