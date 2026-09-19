import Base

# Immutable, and owned by the task rather than the policy. `append` is the
# operation `intercalate` writes its answer with -- the separator goes between
# two pieces, and putting it there is a concatenation. `concat` is what the last
# law observes the answer against: the answer without any separator, which is
# stated without mentioning `intercalate` at all.

def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case a <> rest:
      append(a, concat(rest))
