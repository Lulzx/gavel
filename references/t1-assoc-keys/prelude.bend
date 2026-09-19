import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `assoc_put` and `keys`.

# An association list is a list of these: a key and the value stored under it.
# Bend has no tuples, so the pair is a data type of its own, and the constructors
# are reached through the prelude alias -- `P.Mk{k, v}`, positionally, in
# patterns and in terms alike.
type Entry is Data:
  Mk{k: Nat, v: Nat}

# How many numbers a list of numbers holds. The laws cannot use `plen` below for
# this: a projection of an entry list is a number list, and a length that does
# not look at the elements is the only thing the two lists have in common.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# How many entries an association list holds.
def plen(kvs: List<&2, Entry>) -> Nat:
  match kvs:
    case Nil{}:
      0n
    case h <> t:
      1n + plen(t)
