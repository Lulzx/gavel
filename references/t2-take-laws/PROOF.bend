import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `take_succ` is definitional: `take` steps on the count, so both sides reduce
# to `h <> take(k, xs)`.
def L.take_succ(h, k, xs):
  {==}

# `take_append_len` is inductive in `xs`: `len` and `append` both match on
# their first argument, so with a variable `xs` the goal does not reduce on its
# own. The step case keeps the head that `len` counted and `append` put back,
# which leaves the hypothesis at `t`, `ys` under the cons.
def L.take_append_len(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.take_append_len(t, ys) : {h <> S.take(P.len(t), P.append(t, ys)) == h <> _ : List<Nat>}
      {==}
