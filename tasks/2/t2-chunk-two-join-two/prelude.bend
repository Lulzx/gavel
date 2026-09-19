import Base

# Immutable, and owned by the task rather than the policy. `chunk_two` and
# `join_two` are what the policy writes; the record is the thing they pass each
# other, and it is declared here so that both the laws and the proofs can name
# it without either function having to exist yet.
type Pair is Data:
  MkPair{a: Nat, b: Nat}
