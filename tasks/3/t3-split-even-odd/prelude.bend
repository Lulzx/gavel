import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `split`, and the arithmetic and
# list facts the induction below needs come from here.

# The two lists `split` answers with. Bend has no tuples, so the pair is a data
# type of its own, and the two projections are functions rather than fields.
type PairL is Data:
  MkL{evens: List<&2, Nat>, odds: List<&2, Nat>}

def evens(p: PairL) -> List<&2, Nat>:
  match p:
    case MkL{a, b}:
      a

def odds(p: PairL) -> List<&2, Nat>:
  match p:
    case MkL{a, b}:
      b

# `len` matches on its argument, so with a variable list it does not reduce and
# the work below is an induction rather than an unfolding.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
