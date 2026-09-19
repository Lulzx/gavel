import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the record the target counts over, the test it
# applies, and the `append` the last law adds a record with.

# A record of two numbers. The target counts over a list of these: a list of
# `Nat` cannot hold both halves of a candidate pair, so the laws are stated over
# a list of records instead.
type Pair is Data:
  MkPair{a: Nat, b: Nat}

# `nsub(a, b)` is `a - b` saturating at zero, so it is `0n` exactly when `b` is
# at least `a`.
def nsub(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match b:
        case 0n:
          a
        case 1n+q:
          nsub(p, q)

# The distance between two numbers, which is `0n` exactly when they are equal.
# Both arguments are read twice, so both are marked reusable.
def absdiff(+a: Nat, +b: Nat) -> Nat:
  nsub(a, b) + nsub(b, a)

# `same_put(d)` reads the test's answer off the distance. It takes the distance
# as a parameter rather than computing it, because a match cannot scrutinise a
# computed value.
def same_put(d: Nat) -> Nat:
  match d:
    case 0n:
      1n
    case 1n+q:
      0n

# `same(a, b)` is `1n` when the two halves are equal and `0n` when they are not.
# It is `Nat`-valued rather than `Bool`, so the target's step law is an
# arithmetic statement rather than a premise about a decision.
def same(a: Nat, b: Nat) -> Nat:
  same_put(absdiff(a, b))

def append(ps: List<&2, Pair>, qs: List<&2, Pair>) -> List<&2, Pair>:
  match ps:
    case Nil{}:
      qs
    case MkPair{a, b} <> t:
      MkPair{a, b} <> append(t, qs)
