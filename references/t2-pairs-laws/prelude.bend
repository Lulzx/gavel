import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; `pairs` is what the policy writes.

# The pair two neighbours are packed into. A list of `Nat` cannot hold both
# halves, so the laws are stated over a list of this instead.
type Pair is Data:
  MkPair{a: Nat, b: Nat}

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The length of the list of pairs. The laws cannot use `len` above: the elements
# are pairs, and a length that does not look inside them is the only thing the
# two shapes have in common.
def plen(ps: List<&2, Pair>) -> Nat:
  match ps:
    case Nil{}:
      0n
    case h <> t:
      1n + plen(t)
