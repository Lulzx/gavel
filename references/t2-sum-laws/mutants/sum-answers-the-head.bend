import Base

# The cons case answers the head, so `sum` reads one element and ignores the
# tail. `sum_append` rejects it: at `xs = 1n <> Nil{}` and `ys = 2n <> Nil{}` the
# law's left-hand side is `1n` where its right-hand side is `1n + 2n`.
# `sum_single` is true of the body -- summing a one-element list is that element
# -- and the proof rejects it anyway: the checker stops in `L.sum_single`, whose
# step rewrites with `Policy.add_zero` and looks for `h + 0n`, which this body's
# answer does not contain.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h
