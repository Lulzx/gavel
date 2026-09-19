import Base

# Immutable, and owned by the task rather than the policy. `singletons` is the
# transpose of a single-row matrix written out directly: every element of the
# row becomes a one-element column. It is here so that the law about one-row
# matrices has a right-hand side that does not mention the policy's own
# function -- the point of that law is to say what the transposed shape *is*,
# and a right-hand side built from `transpose` itself would only say that the
# function agrees with itself.

# The one-row matrix whose single row is `r`.
def singletons(r: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match r:
    case Nil{}:
      Nil{}
    case h <> t:
      (h <> Nil{}) <> singletons(t)
