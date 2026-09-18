import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `sum_acc_single` unfolds to `h + 0n`, and `+` is stuck on a variable, so the
# proof needs the fact that adding zero on the right is the identity.
def Policy.add_zero(x: Nat) -> {x + 0n == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + (p + 0n) == 1n + _ : Nat}
      {==}

def L.sum_acc_single(h):
  %Policy.add_zero(h) : {h + 0n == _ : Nat}
  {==}

# `sum_acc_append` is inductive in `xs`. The step case leaves the goal as
# `sum_acc(append(t, ys), h + acc)` against
# `sum_acc(ys, sum_acc(t, h + acc))` -- the hypothesis at `t`, `ys` and the
# head folded into the accumulator. Nothing is consumed twice.
def L.sum_acc_append(xs, ys, acc):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.sum_acc_append(t, ys, h + acc) : {S.sum_acc(P.append(t, ys), h + acc) == _ : Nat}
      {==}
