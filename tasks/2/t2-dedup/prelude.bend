import Base

# Immutable, and owned by the task rather than the policy. `dedup` is what the
# policy implements; `same` and `same_put` are here because the laws are stated
# in terms of them.

# Whether two `Nat`s are the same number. It steps one successor off each side
# at once, so with a variable on either side the answer does not reduce, which
# is why the two laws below carry a `same` on both sides rather than a `Bool{}`.
def same(a: Nat, b: Nat) -> Bool:
  match a b:
    case 0n 0n:
      True{}
    case 0n 1n+bp:
      False{}
    case 1n+ap 0n:
      False{}
    case 1n+ap 1n+bp:
      same(ap, bp)

# `same_put(h, r, k)` is `r` when `k` is `True{}` and `h <> r` otherwise: the
# cons step of `dedup`, with the decision exposed as an argument. A `match`
# cannot scrutinise a computed value in Bend, so the step that has to answer two
# different ways on `same(h, h2)` cannot be written inline.
def same_put(h: Nat, r: List<&2, Nat>, k: Bool) -> List<&2, Nat>:
  match k:
    case True{}:
      r
    case False{}:
      h <> r
