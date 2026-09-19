import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `values` and `sum_values`.

# An association list is a list of these: a key and the value stored under it.
# Bend has no tuples, so the pair is a data type of its own, and the constructors
# are reached through the prelude alias -- `P.Mk{k, v}`, positionally, in
# patterns and in terms alike.
type Entry is Data:
  Mk{k: Nat, v: Nat}

# Storing under a key puts a new entry at the front. The laws reach it; the
# policy does not write it.
def assoc_put(kvs: List<&2, Entry>, k: Nat, v: Nat) -> List<&2, Entry>:
  Mk{k, v} <> kvs

# The sum of a list of numbers, so that the value projection can be compared
# against the value sum without leaving the prelude's own world.
def nsum(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + nsum(t)
