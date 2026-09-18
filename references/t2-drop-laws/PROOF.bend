import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `drop_succ` is definitional: `drop` steps on the count, so both sides reduce
# to `drop(k, t)`.
def L.drop_succ(k, h, t):
  {==}

# `drop_append_len` is inductive in `xs`: `len` and `append` both match on
# their first argument, so with a variable `xs` the goal does not reduce on its
# own. The step case leaves `drop(len(t), append(t, ys))` against `ys`, which
# is the hypothesis at `t` -- the head that `len` counted and `append` put back
# is dropped again. Nothing is consumed twice.
def L.drop_append_len(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.drop_append_len(t, ys) : {S.drop(P.len(t), P.append(t, ys)) == _ : List<Nat>}
      {==}

# `drop_nil` is definitional in both cases of the count: at `0n` the body hands
# back its list argument, and at `1n+k` the inner match on the empty list lands
# on `Nil{}`.
def L.drop_nil(k):
  match k:
    case 0n:
      {==}
    case 1n+kp:
      {==}
