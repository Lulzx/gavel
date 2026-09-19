import Base

# Immutable, and owned by the task rather than the policy. `intersperse` is what
# the policy implements; the three defs here are what the laws are stated in
# terms of -- the length of a list, and the length the answer must have, counted
# without mentioning `intersperse`.

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# How long the answer is once there is something in front of it. `intersperse`
# has a case for the one-element list, so its length cannot be a single
# recurrence over `xs`; this is that recurrence, started one element in.
def ilen_tail(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      2n + ilen_tail(t)

# How long `intersperse(xs, sep)` must be for any `sep`: the empty list answers
# `0n`, and anything else is one element plus `ilen_tail` of its tail.
def ilen(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + ilen_tail(t)
