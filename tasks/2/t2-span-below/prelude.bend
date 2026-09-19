import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the predicate, the pair the answer is, its two
# projections, the length, and the cons step with the decision exposed.

# `le(a, b)` is `True{}` when `a` is at most `b`. It steps one successor off
# each side at once, so it is stuck on a variable and the two cons laws below
# carry its answer as a premise rather than computing it.
def le(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      True{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          le(p, q)

# `split` answers with two lists and Bend has no tuples, so the pair is a data
# type of its own. `front` is the prefix that satisfied the predicate and `back`
# is everything from the first element that did not.
type PairL is Data:
  MkL{front: List<&2, Nat>, back: List<&2, Nat>}

def front(p: PairL) -> List<&2, Nat>:
  match p:
    case MkL{a, b}:
      a

def back(p: PairL) -> List<&2, Nat>:
  match p:
    case MkL{a, b}:
      b

# `len` matches on its argument, so with a variable list it does not reduce and
# the length law below is an induction rather than an unfolding.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `span_put(h, t, p, k)` is the cons step of `span_below` with the decision
# passed in, because a `match` cannot scrutinise a computed value. When the head
# passes it joins the front of the pair the tail produced and the back is that
# pair's back; when it does not, the walk is over, the whole list from that head
# is the back, and the front is empty.
def span_put(h: Nat, t: List<&2, Nat>, +p: PairL, k: Bool) -> PairL:
  match k:
    case True{}:
      MkL{h <> front(p), back(p)}
    case False{}:
      MkL{Nil{}, h <> t}
