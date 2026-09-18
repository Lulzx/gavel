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

# Structural equality on `Nat`s.
def eq(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          True{}
        case 1n+q:
          False{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          eq(p, q)

# A decision as a count: one if the element is the one being looked for.
def ind(b: Bool) -> Nat:
  match b:
    case True{}:
      1n
    case False{}:
      0n

# The cons step of `count`, decision exposed: `r` is the count of the tail.
def count_put(h: Nat, r: Nat, b: Bool) -> Nat:
  match b:
    case True{}:
      1n + r
    case False{}:
      r

def count(+z: Nat, xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +h <> t:
      count_put(h, count(z, t), eq(z, h))
