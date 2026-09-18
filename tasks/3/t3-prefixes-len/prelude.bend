import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# The list of prefixes is a list of lists, and the inner lists have different
# lengths, so the outer list is the task's own type rather than a `List` of
# `List`. Its elements are the prelude's `List<&2, Nat>`, the same list the
# policy's function is over.
type Prefixes is Data:
  PNil{}
  PCons{p: List<&2, Nat>, rest: Prefixes}

# How many prefixes there are. It is not `P.len`, which counts the elements of a
# list of numbers and does not take a `Prefixes` at all.
def llen(ps: Prefixes) -> Nat:
  match ps:
    case PNil{}:
      0n
    case PCons{p, rest}:
      1n + llen(rest)

# Every prefix with one more element on the front, in order. This is what turns
# the prefixes of the tail into the rest of the prefixes of the whole list.
def cons_all(+x: Nat, ps: Prefixes) -> Prefixes:
  match ps:
    case PNil{}:
      PNil{}
    case PCons{p, rest}:
      PCons{x <> p, cons_all(x, rest)}

# The length of a list of numbers, which is what the prefix count is compared
# against.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
