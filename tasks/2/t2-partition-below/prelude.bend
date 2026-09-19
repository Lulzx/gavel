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

# `partition` answers with two lists and Bend has no tuples, so the pair is a
# data type of its own. `front` is the elements that passed the predicate and
# `back` is the elements that did not.
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

# `part_put(h, p, k)` is the cons step of `partition_below` with the decision
# passed in, because a `match` cannot scrutinise a computed value. Unlike a
# `span`, neither answer ends the walk: the head joins the front of the pair
# when it passes and the back of the pair when it does not, and the other field
# is taken from the pair the tail produced either way.
def part_put(h: Nat, +p: PairL, k: Bool) -> PairL:
  match k:
    case True{}:
      MkL{h <> front(p), back(p)}
    case False{}:
      MkL{front(p), h <> back(p)}
