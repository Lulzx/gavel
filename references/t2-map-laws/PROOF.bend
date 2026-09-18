import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `len_map` is inductive in `xs`; the cons case pushes the operation one step
# into the tail, where the induction hypothesis applies.
def L.len_map(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.len_map(t) : {1n+S.len(S.map(t)) == 1n+_ : Nat}
      {==}

# `map_cons` is what `map` computes at a cons, so it closes without induction.
def L.map_cons(h, t):
  {==}
