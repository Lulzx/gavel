import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `nappend`, and the two lemmas
# that compare lengths.

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the length lemma below to the induction
# rather than to the unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The length of a list. It matches on its first argument for the same reason,
# and the laws are stated in terms of it rather than in terms of the checker's
# own list length so that the vocabulary is the prelude's.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
