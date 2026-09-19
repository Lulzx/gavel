import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; `row` and `cross` are what the policy writes.

# The pair one cell of the product is. Base's `List` is monomorphic, so a list
# of `Nat` cannot hold both halves; the product is a list of this instead, and
# like every pair in the bank this one is introduced by the task.
type Pair is Data:
  MkPair{a: Nat, b: Nat}

# Concatenation, at the element type of the answer. The policy's two functions
# are both recursive on a list of `Nat`, so a `Nat` list cannot be their
# accumulator; this is `append` one type up, and it is what the law that unfolds
# the outer walk has to name.
def append(ps: List<&2, Pair>, qs: List<&2, Pair>) -> List<&2, Pair>:
  match ps:
    case Nil{}:
      qs
    case h <> t:
      h <> append(t, qs)
