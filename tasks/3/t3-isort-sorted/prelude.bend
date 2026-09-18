import Base

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

# True iff `h <> t` is sorted, given the decision `k` about `h` against the
# element before it. The decision is a parameter because a `match` cannot
# scrutinise the computed `le(prev, h)`.
def sorted_put(t: List<&2, Nat>, +h: Nat, k: Bool) -> Bool:
  match t:
    case Nil{}:
      k
    case +h2 <> t2:
      match k:
        case False{}:
          False{}
        case True{}:
          sorted_put(t2, h2, le(h, h2))

# `xs` is sorted: pretend a `0n` precedes it, so the first decision is settled.
def is_sorted(xs: List<&2, Nat>) -> Bool:
  sorted_put(xs, 0n, True{})

# The cons step of `insert`, with the decision exposed as an argument: a `match`
# cannot scrutinise the computed `le(y, h)`, so `insert` recurses on the list and
# defers the decision to here. `h` and `t` are the list the caller matched.
def insert_put(t: List<&2, Nat>, +h: Nat, +y: Nat, k: Bool) -> List<&2, Nat>:
  match t:
    case Nil{}:
      match k:
        case True{}:
          y <> h <> Nil{}
        case False{}:
          h <> y <> Nil{}
    case +h2 <> t2:
      match k:
        case True{}:
          y <> h <> h2 <> t2
        case False{}:
          h <> insert_put(t2, h2, y, le(y, h2))
