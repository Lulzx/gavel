import Base

# Immutable, and owned by the task rather than the policy. One row of two
# numbers, which is the thing the two functions below pass each other: a list of
# `Nat` cannot hold both halves, so the laws are stated over a list of these
# instead. Nothing else is needed: the arithmetic the laws do is `+`, which the
# base already has.
type Pair is Data:
  MkPair{a: Nat, b: Nat}
