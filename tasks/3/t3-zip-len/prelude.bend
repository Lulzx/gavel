import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `zip`.

# The pair the zipped list is made of. A `List<&2, Nat>` cannot hold both halves
# of a pair, so the laws are stated over a list of this instead.
type P2 is Data:
  Mk{a: Nat, b: Nat}

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The length of the zipped list. The laws cannot use `len` above: the elements
# are pairs, and a length that does not look at the elements is the only thing
# the two lists have in common.
def zlen(xs: List<&2, P2>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + zlen(t)

# `min` matches on its first argument and then on its second, so with two
# variables the goal does not reduce, and that is what leaves the work below to
# the induction rather than to the unfolding.
def min(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match b:
        case 0n:
          0n
        case 1n+q:
          1n + min(p, q)
