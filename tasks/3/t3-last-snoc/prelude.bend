import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `last`, and the lemma that
# carries its default through the recursion.

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the work below to the induction rather
# than to the unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# One element on the end. The laws are stated with this rather than with a
# literal cons so that the term they talk about is the prelude's, and the
# policy's function is the only thing under test.
def snoc(xs: List<&2, Nat>, x: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      h <> snoc(t, x)
