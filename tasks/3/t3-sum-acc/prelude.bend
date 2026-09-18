import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes the accumulator version of the
# same function, and the lemmas that compare them.

# The plain sum. It matches on its first argument, so with a variable list the
# goal does not reduce, and that is what forces every proof below to be an
# induction rather than an unfolding.
def sum(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)
