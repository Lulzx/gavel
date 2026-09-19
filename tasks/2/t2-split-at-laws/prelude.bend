import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the pair the answer is, its two projections, and
# the `append` the decomposition law puts the halves back together with.

# The two halves of a split. The elements are `&2` so that a head can be read
# once for the first half and the tail's pair can be read once for each half.
type Duo is Data:
  MkDuo{left_half: List<&2, Nat>, right_half: List<&2, Nat>}

def left_half(p: Duo) -> List<&2, Nat>:
  match p:
    case MkDuo{l, r}:
      l

def right_half(p: Duo) -> List<&2, Nat>:
  match p:
    case MkDuo{l, r}:
      r

def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)
