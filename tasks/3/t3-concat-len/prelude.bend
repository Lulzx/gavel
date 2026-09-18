import Base

# Immutable, and owned by the task rather than the policy. `concat` is what the
# policy implements; `sum_lens` and `sum_sums` measure a list of lists without
# flattening it, which is what makes the laws statements about `concat` rather
# than about these alone.

# `append` matches on its first argument, so `append(h, concat(t))` is stuck
# until `concat(t)` is a cons.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)

# The number of elements `concat` is going to produce, counted a piece at a
# time: the lengths added up, without ever building the flattened list.
def sum_lens(xss: List<List<Nat>>) -> Nat:
  match xss:
    case Nil{}:
      0n
    case h <> t:
      len(h) + sum_lens(t)

# And the same with `sum` in place of `len`, which is the finer measure of the
# two: it says which elements survive the flattening, not only how many.
def sum_sums(xss: List<List<Nat>>) -> Nat:
  match xss:
    case Nil{}:
      0n
    case h <> t:
      sum(h) + sum_sums(t)
