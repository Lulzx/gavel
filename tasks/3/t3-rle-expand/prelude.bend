import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `expand`, and the lemmas that
# carry lengths through the two functions it is built from.

# A run: a value and how many times it is repeated. The encoding direction --
# taking a flat list and finding its maximal runs -- cannot be written here at
# all, because deciding whether two adjacent elements are equal is a *computed*
# decision and a `match` may only scrutinise a parameter or a field, not a call.
# So the task is the other direction: a list of runs, decoded.
type Run is Data:
  Mk {v: Nat, k: Nat}

# `n` copies of one value. The laws are stated through this rather than through
# a literal cons so that the term they talk about is the prelude's.
def repeat(+x: Nat, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      x <> repeat(x, p)

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the length lemma below to the induction
# rather than to the unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The total number of values the runs stand for -- the sum of the counts. It is
# the prelude's, so that the work law has a term to compare a length against.
def sum_k(rs: List<&2, Run>) -> Nat:
  match rs:
    case Nil{}:
      0n
    case Mk{v, k} <> t:
      k + sum_k(t)
