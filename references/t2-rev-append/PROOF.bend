import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `rev_append_single` is definitional: `rev_append` steps on the cons cell, so
# both sides reduce to `h <> ys`.
def L.rev_append_single(h, ys):
  {==}

# `rev_append_append` is inductive in `xs`. The step case leaves the goal as
# `rev_append(append(t, ys), h <> zs)` against
# `rev_append(ys, rev_append(t, h <> zs))` -- which is the hypothesis at `t`,
# `ys` and the head carried onto the accumulator. `h` was matched out of `xs`,
# so it is the one that moves; nothing is consumed twice.
def L.rev_append_append(xs, ys, zs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.rev_append_append(t, ys, h <> zs) : {S.rev_append(P.append(t, ys), h <> zs) == _ : List<Nat>}
      {==}
