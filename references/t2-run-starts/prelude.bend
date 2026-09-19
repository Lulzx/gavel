import Base

# Immutable, and owned by the task rather than the policy. `run_starts` is what
# the policy implements; `same` and `put_start` are here because the laws are
# stated in terms of them, and because the walk's step has to answer two
# different ways on a comparison that is not an argument.

# Whether two `Nat`s are the same number. It steps one successor off each side
# at once, so with a variable on either side the answer does not reduce: that a
# number is the same as itself is an induction and not an unfolding, which is
# what the law about a continuing run needs.
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

# `put_start(i, r, k)` is `r` when `k` is `True{}` and `i <> r` otherwise: the
# walk's step, with the decision exposed as an argument. `k` is whether the
# element at position `i` is the same as the one before it, so a `True{}`
# continues the run and a `False{}` opens a new one at `i`. A `match` cannot
# scrutinise a computed value in Bend, so a step that has to answer two
# different ways on `same(h, prev)` cannot be written inline.
def put_start(i: Nat, r: List<&2, Nat>, k: Bool) -> List<&2, Nat>:
  match k:
    case True{}:
      r
    case False{}:
      i <> r
