import Base

# Immutable, and owned by the task rather than the policy. `concat` flattens a
# list of lists, so it needs `append` at the element type; the law also appends
# one whole list onto the outer list, which is a second `append` because
# Base's `List` is monomorphic.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def append_ll(xss: List<&2, List<&2, Nat>>, ys: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match xss:
    case Nil{}:
      ys <> Nil{}
    case a <> rest:
      a <> append_ll(rest, ys)
