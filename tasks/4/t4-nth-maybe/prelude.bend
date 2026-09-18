import Base

# Immutable, and owned by the task rather than the policy. `len` is what the
# range premise of the two conditional laws is stated against, and `is_some` is
# how a law observes a `Maybe` without spelling the kind arguments of
# `Maybe.is_some` at every use. Both match on their first argument, so with a
# variable neither reduces, and that is what leaves the laws about them to an
# induction.

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `Maybe` is a sum type: an answer that may be missing is either `None{}` or
# `Some{x}`, and the only thing a law can say about one is which branch it took.
# This is that question, as a `Bool`, so the domain laws read as propositions.
def is_some(m: Maybe<&2, Nat>) -> Bool:
  match m:
    case None{}:
      False{}
    case Some{x}:
      True{}
