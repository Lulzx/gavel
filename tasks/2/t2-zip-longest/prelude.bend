import Base

# Immutable, and owned by the task rather than the policy. The pair is what the
# two zipped elements are packed into, and it is here -- rather than in Base --
# because a list of `Nat` cannot hold both halves and the laws are stated over a
# list of this instead.
type Pair is Data:
  MkPair{a: Nat, b: Nat}
