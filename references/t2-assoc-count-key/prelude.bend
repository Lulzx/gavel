import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `count_key`.

# An association list is a list of these: a key and the value stored under it.
# Bend has no tuples, so the pair is a data type of its own, and the constructors
# are reached through the prelude alias -- `P.Mk{k, v}`, positionally, in
# patterns and in terms alike.
type Entry is Data:
  Mk{k: Nat, v: Nat}

# The decision the count needs. `P.key_select(a, b, x, y)` is `x` when `a` and
# `b` are the same key and `y` otherwise, decided by structural descent on both
# numbers. It has to be a def rather than a `match` in the body because a match
# cannot scrutinise a computed comparison, and it returns a `Nat` so that the
# counting can choose between `1n` more and the same count.
def key_select(a: Nat, b: Nat, x: Nat, y: Nat) -> Nat:
  match a:
    case 0n:
      match b:
        case 0n:
          x
        case 1n+q:
          y
    case 1n+p:
      match b:
        case 0n:
          y
        case 1n+q:
          key_select(p, q, x, y)

# Storing under a key puts the new entry at the front. It is here because one of
# the laws below states what the count does to a store; the policy writes the
# count, not this.
def assoc_put(kvs: List<&2, Entry>, k: Nat, v: Nat) -> List<&2, Entry>:
  Mk{k, v} <> kvs
