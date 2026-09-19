import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list is a literal `Nil{}`, so the match takes the empty branch whatever
# the accumulator is and answers without looking at it.
def L.scan_add_nil(acc):
  {==}

# `h <> Nil{}` is a cons cell, so the match takes the cons branch, emits
# `acc + h` and walks the tail, which is `Nil{}` again.
def L.scan_add_single(h, acc):
  {==}

# Inductive in `xs`. The step case leaves the goal as
# `(acc + h) <> scan_add(append(t, ys), acc + h)` against
# `(acc + h) <> append(scan_add(t, acc + h), scan_add(ys, acc_after(t, acc + h)))`
# -- the hypothesis at the tail, with the head already folded into the
# accumulator, is exactly the term sitting after the emitted total.
def L.scan_add_append(xs, ys, acc):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.scan_add_append(t, ys, acc + h) : {(acc + h) <> S.scan_add(P.append(t, ys), acc + h) == (acc + h) <> _ : List<Nat>}
      {==}
