import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `assoc_lookup`.

# An association list is a list of these: a key and the value stored under it.
# Bend has no tuples, so the pair is a data type of its own, and the constructors
# are reached through the prelude alias -- `P.Mk{k, v}`, positionally, in
# patterns and in terms alike.
type Entry is Data:
  Mk{k: Nat, v: Nat}

# The decision the search needs. `P.key_select(a, b, x, y)` is `x` when `a` and
# `b` are the same key and `y` otherwise, decided by structural descent on both
# numbers. It has to be a def rather than a `match` in the body because a match
# cannot scrutinise a computed comparison, and it returns a `Nat` so that the
# answer can be chosen rather than merely tested.
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
