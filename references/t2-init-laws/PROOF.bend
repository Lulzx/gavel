import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Definitional: the one-element list takes the cons case of the match and then
# the `Nil{}` case of the match on its tail.
def L.init_single(h):
  {==}

# An induction in `xs`, and inside each case a split on the tail `t`: with `t` a
# variable, the match inside `init` has nothing to step on. The `Nil{}` case is
# the empty list; the one-element case is definitional once `init` has seen the
# `Nil{}` tail; the longer case keeps its head and hands the hypothesis the tail
# `h2 <> t2`.
def L.init_snoc(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      match t:
        case Nil{}:
          {==}
        case h2 <> t2:
          %L.init_snoc(h2 <> t2, x) : {h <> S.init(P.append(h2 <> t2, x <> Nil{})) == h <> _ : List<Nat>}
          {==}
